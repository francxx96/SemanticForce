
package ner;

import java.util.ArrayList;
import java.util.Objects;

/**
 * This class represents the object containing the text, the category, 
 * the position, and the keywords associated with the entity.
 * @author emili
 */
public class Entity {
    
    private String name, type;
    private int startPos, endPos;
    private ArrayList<String> keyWords;
    private String kWords;

    public String getkWords() {
        return kWords;
    }

    public void setkWords(String kWords) {
        this.kWords = kWords;
    }

    
    
    public Entity() {
    }

    public Entity(String name, String type, int startPos, int endPos) {
        this.name = name;
        this.type = type;
        this.startPos = startPos;
        this.endPos = endPos;
        this.keyWords = new ArrayList<>();
    }

    
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
 
    public int getStartPos() {
        return startPos;
    }

    public void setStartPos(int startPos) {
        this.startPos = startPos;
    }

    public int getEndPos() {
        return endPos;
    }

    public void setEndPos(int endPos) {
        this.endPos = endPos;
    }
    
    public ArrayList<String> getKeyWords() {
        return keyWords;
    }

    public void setKeyWords(ArrayList<String> keyWords) {
        this.keyWords = keyWords;
    }    

    
    @Override
    public int hashCode() {
        int hash = 5;
        hash = 89 * hash + Objects.hashCode(this.type);
        hash = 89 * hash + Objects.hashCode(this.name);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Entity other = (Entity) obj;
        if (!Objects.equals(this.type, other.type)) {
            return false;
        }
        if (!Objects.equals(this.name, other.name)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Name:"+name + "\t- Type:"+type + "\t- Position:"+startPos + "\t- KeyWords:"+keyWords + "\n";
    }
    
}
