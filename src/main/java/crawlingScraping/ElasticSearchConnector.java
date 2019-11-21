package crawlingScraping;

import java.io.FileReader;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.elasticsearch.*;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthResponse;
import org.elasticsearch.action.admin.indices.create.CreateIndexResponse;
import org.elasticsearch.action.admin.indices.exists.indices.IndicesExistsResponse;
import org.elasticsearch.action.bulk.BulkRequestBuilder;
import org.elasticsearch.action.bulk.BulkResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.elasticsearch.action.search.*;
import org.elasticsearch.action.support.WriteRequest.RefreshPolicy;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.TransportAddress;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.reindex.BulkByScrollResponse;
import org.elasticsearch.index.reindex.DeleteByQueryAction;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.sort.FieldSortBuilder;
import org.elasticsearch.search.sort.SortOrder;
//IMPORTARE QUESTE LIBRERIE PER IL FILE JSON
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class ElasticSearchConnector {
    /*TransportClient si collega in remoto a un cluster Elasticsearch utilizzando il modulo di trasporto.
    Non si aggiunge al cluster, ma semplicemente ottiene uno o più indirizzi di trasporto iniziali e comunica 
    con loro in modalità round robin su ciascuna azione */
    private TransportClient client = null;
    static final Logger logger = Logger.getLogger(ElasticSearchConnector.class.getName());
	
    public ElasticSearchConnector( String clusterName, String clusterIp, int clusterPort ) throws UnknownHostException {
        Settings settings = Settings.builder()
            /*imposta il nome del cluster ad ElasticSearch*/
            .put( "cluster.name", clusterName )
            /*Impostare su true per ignorare la convalida del nome del cluster dei nodi connessi.*/
            .put( "client.transport.ignore_cluster_name", true )
            /*abilita lo sniffing nel cluster*/
            .put( "client.transport.sniff", true )
            .build();
            /*creo un oggetto del tipo PreBuiltTransportClient a cui passo i parametri settati in precedenza*/
        client = new PreBuiltTransportClient( settings ); 
        /*Il client di trasporto viene fornito con una funzione di sniffing del cluster che consente di aggiungere nuovi host in modo 
        dinamico e rimuovere quelli vecchi. Quando lo sniffing è abilitato, il client di trasporto si connetterà ai nodi nel proprio elenco 
        di nodi interni, che viene creato tramite chiamate a addTransportAddress. Dopodiché, il client chiamerà l'API dello stato del cluster 
        interno su tali nodi per rilevare i nodi dati disponibili. L'elenco di nodi interni del client verrà sostituito solo con quei nodi di dati. 
        Questo elenco viene aggiornato ogni cinque secondi per impostazione predefinita. Si noti che gli indirizzi IP a cui si connette lo sniffer sono 
        quelli dichiarati come indirizzo di pubblicazione nella configurazione Elasticsearch di quel nodo.*/
                                
        /*con il metodo "InetAddress" consente di creare un indirizzo IP, ovvero di darlo in pasto a JAVA per poter reindirizzare il tutto al server desiderato. 
        Viene fornito allo stesso l'IP del cluster (ElasticSearch) e quello della porta dove è in ascolto il server.*/
        client.addTransportAddress( new TransportAddress( InetAddress.getByName( clusterIp ), clusterPort) );
        /*invia all'oggetto 'logger' il messaggio passato per argomento*/
        logger.info( "Connection " + clusterName + "@" + clusterIp + ":" + clusterPort + " established!" );		
    }
    
    public boolean isClusterHealthy() {
        /*l'ggetto ClusterHealthResponse è un oggetto iterabile sulla risposta fornita dal cluster*/
        final ClusterHealthResponse response = client
            .admin()
            .cluster()
            .prepareHealth()
            .setWaitForGreenStatus()
            .setTimeout( TimeValue.timeValueSeconds( 2 ) )
            .execute()
            .actionGet();
 
        if ( response.isTimedOut() ) {
            logger.info( "The cluster is unhealthy: " + response.getStatus() );
            return false;
        }
 
        logger.info( "The cluster is healthy: " + response.getStatus() );
        return true;
    }
        
    public boolean isIndexRegistered( String indexName ) {
        // check if index already exists
        /*//funzione per verificare se l'indice esiste già in base alla risposta ricevuta dalla funzione IndicesExistsResponse*/
        final IndicesExistsResponse ieResponse = client
            .admin()
            .indices()
            .prepareExists( indexName )
            .get( TimeValue.timeValueSeconds( 1 ) );
        // index not there
        if ( !ieResponse.isExists() ) {
            return false;
        }
        logger.info( "Index already created!" );
        return true;
    }
        
    public boolean createIndex( String indexName, String numberOfShards, String numberOfReplicas ) {
        /*Creo un 'indexResponse' ovvero un oggetto per poter configurare le richieste di creazione dell'indice */
        CreateIndexResponse createIndexResponse = 
            client.admin().indices().prepareCreate( indexName )
                .setSettings( Settings.builder()             
                    .put("index.number_of_shards", numberOfShards ) 
                    .put("index.number_of_replicas", numberOfReplicas )
                )
                .get(); 
             /*il metodo 'isAcknowledged()' Indica se tutti i nodi hanno riconosciuto la richiesta*/
        if( createIndexResponse.isAcknowledged() ) {
            logger.info("Created Index with " + numberOfShards + " Shard(s) and " + numberOfReplicas + " Replica(s)!");
            return true;
        }
             return false;				
	}
        
    public boolean bulkInsert( String indexName, String indexType ) throws IOException { 
        /*L'API bulk consente di indicizzare ed eliminare diversi documenti in una singola richiesta*/
        BulkRequestBuilder bulkRequest = client.prepareBulk();
		
        // o utilizzare #client#prepare o utilizzare Requests# per creare direttamente le richieste di indice/eliminazione
        /*setRefreshPolicy ci permette di attuare una politica di reazioni dal momento che vi è una modifica sulla stringa. 
        Le possibili politiche sono: IMMEDIATE - WAIT_UNTIL - NONE*/
        bulkRequest.setRefreshPolicy( RefreshPolicy.IMMEDIATE ).add( 
            client.prepareIndex( indexName, indexType, null ) //preparo la struttura della tupla da inserire (Nome, Tipo, ID) (in pratica imposto i parametri dei field)
                .setSource( XContentFactory.jsonBuilder()
                    .startObject()
                    .field( "name", "Mark Twain" )
                    .field( "age", 75 )
                    .endObject()
	    ));

        bulkRequest.setRefreshPolicy( RefreshPolicy.IMMEDIATE ).add( 
            client.prepareIndex( indexName, indexType, null )
                .setSource( XContentFactory.jsonBuilder()
                    .startObject()
                    .field( "name", "Tom Saywer" )
                    .field( "age", 12 )
                    .endObject()
        ));
		
        bulkRequest.setRefreshPolicy( RefreshPolicy.IMMEDIATE ).add( 
            client.prepareIndex( indexName, indexType, null )
                .setSource( XContentFactory.jsonBuilder()
                    .startObject()
                    .field( "name", "John Doe" )
                    .field( "age", 20 )
                    .endObject()
        ));
		
        bulkRequest.setRefreshPolicy( RefreshPolicy.IMMEDIATE ).add( 
            client.prepareIndex( indexName, indexType, null )
                .setSource( XContentFactory.jsonBuilder()
                    .startObject()
                    .field( "name", "Peter Pan" )
                    .field( "age", 15 )
                    .endObject()
        ));
		
        bulkRequest.setRefreshPolicy( RefreshPolicy.IMMEDIATE ).add( 
            client.prepareIndex( indexName, indexType, null )
                .setSource( XContentFactory.jsonBuilder()
                    .startObject()
                    .field( "name", "Johnnie Walker" )
                    .field( "age", 37 )
                    .endObject()
        ));

        BulkResponse bulkResponse = bulkRequest.get();
        if ( bulkResponse.hasFailures() ) {
            // process failures by iterating through each bulk response item
            logger.info( "Bulk insert failed!" );
            return false;
        }
            return true;
    }
    
    public boolean bulkInsertArticle( String indexName, String indexType, Article art ) throws IOException {
        BulkRequestBuilder bulkRequest = client.prepareBulk();
        
        bulkRequest.setRefreshPolicy( RefreshPolicy.IMMEDIATE ).add( 
            client.prepareIndex( indexName, indexType, null )
                .setSource( XContentFactory.jsonBuilder()
                    .startObject()
                    .field( "Title", art.getTitle())
                    //.field( "Author", art.getAuthor())
                    .field( "Text", art.getText())
                    .endObject()
        ));
        
        BulkResponse bulkResponse = bulkRequest.get();
        if ( bulkResponse.hasFailures() ) {
            // process failures by iterating through each bulk response item
            logger.info( "Bulk insert failed!" );
            return false;
        }
            return true;
    }
    	public boolean bulkInsert( String indexName, String indexType, String dataPath ) throws IOException, ParseException { 
		BulkRequestBuilder bulkRequest = client.prepareBulk();
		
		JSONParser parser = new JSONParser();
		// we know we get an array from the example data
		JSONArray jsonArray = (JSONArray) parser.parse( new FileReader( dataPath ) );
	    
		@SuppressWarnings("unchecked")
		Iterator<JSONObject> it = jsonArray.iterator();
	    
	    while( it.hasNext() ) {
	    	JSONObject json = it.next();
	    	logger.info( "Insert document: " + json.toJSONString() );	
	    	
			bulkRequest.setRefreshPolicy( RefreshPolicy.IMMEDIATE ).add( 
				client.prepareIndex( indexName, indexType )
					.setSource( json.toJSONString(), XContentType.JSON )
			);
	    }
        
		BulkResponse bulkResponse = bulkRequest.get();
		if ( bulkResponse.hasFailures() ) {
			logger.info( "Bulk insert failed: " + bulkResponse.buildFailureMessage() );
			return false;
		}
		
		return true;
	}
        	
    public void queryResultsWithAgeFilter( String indexName, int from, int to ) {
        SearchResponse scrollResp = 
            client.prepareSearch( indexName )
                // sort order
	        .addSort( FieldSortBuilder.DOC_FIELD_NAME, SortOrder.ASC )
	        // keep results for 60 seconds
	        .setScroll( new TimeValue( 60000 ) )
	        // filter for age
	        .setPostFilter( QueryBuilders.rangeQuery( "age" ).from( from ).to( to ) )
	        // maximum of 100 hits will be returned for each scroll
	        .setSize( 100 ).get(); 
		
		// scroll until no hits are returned
        do {
            int count = 1;
            for ( SearchHit hit : scrollResp.getHits().getHits() ) { //ottengo un oggetto iterabile ed utilizzo il metodo getHits per andare avanti nell'oggetto
                Map<String,Object> res = hit.getSourceAsMap(); //torna i valori di 'hit' come una mappa chiave-valore
                // print results
                for( Map.Entry<String,Object> entry : res.entrySet() ) {
                    logger.info( "[" + count + "] " + entry.getKey() + " --> " + entry.getValue() );
                }
                count++;
            }

            scrollResp = client.prepareSearchScroll( scrollResp.getScrollId() ).setScroll( new TimeValue(60000) ).execute().actionGet();
            // zero hits mark the end of the scroll and the while loop.
            } while( scrollResp.getHits().getHits().length != 0 ); 
    }
                
    public long delete( String indexName, String key, String value ) {
        BulkByScrollResponse response =
            DeleteByQueryAction.INSTANCE.newRequestBuilder( client )
                .filter( QueryBuilders.matchQuery( key, value ) ) 
                .source( indexName )
                .refresh( true )
                .get();                                             

        logger.info( "Deleted " + response.getDeleted() + " element(s)!" );
		
        return response.getDeleted();
    }
    
    public String idQuery (String index){
        String yourId=null;
        QueryBuilder qb = QueryBuilders.matchQuery("titolo","giallinoolo");
        SearchResponse searchResponse = client.prepareSearch(index).setQuery(qb).get(); 
        for (SearchHit hit : searchResponse.getHits()) { 
            yourId = hit.getId(); 
        } 
        return yourId;
    }
   
    public void updateQuery (String index,String type,String id){
        UpdateRequest updateRequest = new UpdateRequest();
        updateRequest.index(index);
        updateRequest.type(type);
        updateRequest.id(id);
        try {
            updateRequest.doc(XContentFactory.jsonBuilder()
                    .startObject()
                    .field("titolo", "giallinoolo")
                    .field("caazone","beeeello")
                    .endObject());
        } catch (IOException ex) {
            Logger.getLogger(ElasticSearchConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
        try { 
            client.update(updateRequest).get();
        } catch (InterruptedException ex) {
            Logger.getLogger(ElasticSearchConnector.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ExecutionException ex) {
            Logger.getLogger(ElasticSearchConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
        
    public void close() {
        if( client != null ) client.close();
    }
	
}
