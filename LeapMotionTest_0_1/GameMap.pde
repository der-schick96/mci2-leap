public class GameMap {
  GameMap() {
    places = new ArrayList<Place>();
  }
  
  
  // TODO: Add XML Serialization
  /*GameMap(String filepath) {
    places = new ArrayList<Place>();
    XML xml = loadXML(filepath);
    XML[] places = xml.getChildren("Place");
    
  }*/
  
  public XML toXML() {
    XML xml = parseXML("<Map></Map>");
    for(Place place : places)
      xml.addChild(place.toXML());
    return xml;
  }
  
  public void addPlace(Place place) {
    places.add(place); 
  }
  
  
  public ArrayList<Place> getPlacesByPosition(float x, float y) {
    ArrayList<Place> ret = new ArrayList<Place>();
    for(Place place : places)
      if (place.contains(x, y))
        ret.add(place);
    return ret;
  }
  
  public ArrayList<Place> getPlacesByPosition(PVector position) {
    return getPlacesByPosition(position.x, position.y);
  }
  
  private ArrayList<Place> places;
}

public class Place {
  private String name;
  private float x, y, width, height;
  
  public Place(float newX, float newY, float newWidth, float newHeight, String newName) {
    x = newX;
    y = newY;
    width = newWidth;
    height = newHeight;
    name = newName;
  }
  
  @Override
  public String toString() {
     return name; 
  }
  
  public String getName() {
     return name; 
  }
  
  public void draw(float offsetX, float offsetY, float scale) {
     noFill();
     stroke(0x000000);
     rect((x + offsetX), (y + offsetY), width, height);
     text(name, (x + offsetX), (y + offsetY + height));
  }
  
  public boolean contains(float x, float y) {
    return x > this.x && x < this.x + this.width && y > this.y && y < this.y+ this.height;
  }
  
  public XML toXML() {
    return parseXML("<Place><x>"+x+"</x><y>"+y+"</y><width>"+width+"</width><height>"+height+"</height><name>"+name+"</name></Place>");
  }
}
