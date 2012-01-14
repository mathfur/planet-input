
var SolarSystem = function(elem, x, y, w, h, r, r2){
  this.elem = elem;
  this.x = x;
  this.y = y;
  this.w = w;
  this.h = h;
  this.r = r;
  this.r2 = r2;

  this.planets = [];
  this.elem.append($('<svg width='+ w +' height='+ h +' />'));

  this.addPlanet = function(planet){
    this.planets << planet;
    var content = this;
    var svg = this.elem.find('svg');
    svg.append(planet.elem);
    var satellite_num = planet.satellites.length;
    $.each(planet.satellites,function(i){
      if(0 < satellite_num){
        this.reflesh_location(
          planet.x + content.r2*Math.cos(2*Math.PI*i/satellite_num),
          planet.y + content.r2*Math.sin(2*Math.PI*i/satellite_num),
          5
        );
      };
      svg.append(this.elem);
    });
  }
}

var Planet = function(x, y, r){
  this.x = x;
  this.y = y;
  this.r = r;
  this.satellites = [];
  this.elem = $(document.createElementNS('http://www.w3.org/2000/svg', 'circle')).attr({cx: this.x, cy:this.y, r:this.r});
  this.addSatellite = function(satellite){
    this.satellites.push(satellite);
  }
}

var Satellite = function(hash, satellite_tooltip, satellite_editor){
  this.hash = hash;
  this.satellite_editor = satellite_editor;
  this.satellite_tooltip = satellite_tooltip;
  this.satellite_id = Math.floor(Math.random()*1000000);

  this.elem = $(document.createElementNS('http://www.w3.org/2000/svg', 'circle'));

  this.delete = function(){
    this.elem.remove();
  }
  this.reflesh_location = function(x, y, r){
    this.elem.attr('cx', x);
    this.elem.attr('cy', y);
    this.elem.attr('r', r);
  }

  var content = this;
  this.elem.click(function(){
    content.satellite_editor.show(content, content.hash);
  });
}

var SatelliteEditor = function(parent_elem, ok){
  this.parent_elem = parent_elem;
  this.ok = ok;
  var content = this;
  this.elem = $('<form id="satellite_editor_form"><table/><button id=\'satellite_editor_cancel\'>cancel</button><button id=\'satellite_editor_ok\'>ok</button></form>', parent_elem);
  this.elem.find('#satellite_editor_ok').click(function(){
    var result = {};
    $('#satellite_editor_form').find('input').each(function(){
      result[$(this).attr('name')] = $(this).val();
    }); 
    content.ok(result['satellite-id'], result);
    content.dispose();
    return false;
  });
  this.elem.find('#satellite_editor_cancel').click(function(){
    content.dispose();
    return false;
  });
  this.dispose = function(){
    content.elem.find('tr').remove();
  }
  this.parent_elem.prepend(this.elem);
  this.show = function(satellite, hash){
    var content = this;
    content.elem.find('table').empty();
    $.each(hash,function(k, v){
      content.elem.find('table:first')
        .after( $("<input type=hidden name=satellite-id value='" + satellite.satellite_id + "'/>") )
      .prepend(
        $('<tr/>').css({
          display: 'block'
        }).append($('<td>'+ k +'</td><td><input name="'+ k +'" type=text value="' + v + '"/></td>'))
      )
    });
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
