
var SolarSystem = function(parent, x, y, w, h, r, r2, planet_attrs){
  this.x = x;
  this.y = y;
  this.w = w;
  this.h = h;
  this.r = r;
  this.r2 = r2;
  this.planet_attrs = planet_attrs;

  this.addPlanet = function(){
    this.planets << planet;
    var content = this;
    var svg = this.elem.find('svg');
    svg.append(planet.elem);
    var satellite_num = planet.satellites.size;
    $.each(planet.satellites,function(i){
      this.reflesh_location(
        content.x + content.r2*Math.cos(Math.PI*i/satellite_num),
        content.y + content.r2*Math.sin(Math.PI*i/satellite_num)
        );
    });
  }
}

var Planet = function(x, y, r){
  this.x = x;
  this.y = y;
  this.r = r;
  this.addSatellite = function(){
    this.satellites << satellite;
  }
}

var Satellite = function(hash, satellite_tooltip, satellite_editor){
  this.x = x;
  this.y = y;
  this.r = r;
  this.satellite_editor = satellite_editor;
  this.satellite_tooltip = satellite_tooltip;
  this.delete = function(){
    self_elem.remove();
  }
  this.reflesh_location = function(){

  }
}

var SatelliteEditor = function(satellite){
  this.satellite = satellite;
  this.show = function(){
    $.each(this.hash,function(){
      content.prepend(
        $('tr').css({
          display: 'block'
        }).append($('<td>this.key</td><td><input value=”#{this.value}”></td>'))
      );
    });
  }
  this.dispose = function(){
    this.elem.find('tr').remove();
  };
  this.ok = function(){
    this.ok_handler(this.elem.find('input')); // TODO .map();
    this.dispose();
  }
}

var SatelliteTooltip = function(){
  this.show = function(){
  }
  this.hide = function(){
  }
  this.disabled = function(){
  }
}
