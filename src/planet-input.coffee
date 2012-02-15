# TODO: <g>を加える
# 最初のトリガー部分
# tdテーブル

$ ->
  lg = console.log

  $.obj2table = (obj, options={}) ->
      inner = ''
      if options.edit
        inner = $.map(obj||{}, (v, k) -> "<tr><td>#{k}</td><td><input name='#{k}' value='#{v}'/></td></tr>")
      else
        inner = $.map(obj||{}, (k, v) -> "<tr><td>#{k}</td><td>#{v}</td></tr>")
      $("<table>#{inner.join('')}</table>")
  $('#draw-area').svg()
  $('#draw-area').bind 'add-planet', (event, x, y, r1, r2, r3, planet_id, hashs) ->
    console.log '>>add-planet', x, y, r1, r2, r3, planet_id, hashs
    draw_area = $(this).click ->
      console.log '>>#draw_area.click'
      $('#satellite-editor').trigger('close')
    svg = $(this).svg('get')
    $('#'+planet_id).remove()
    g = svg.group({id: planet_id})
    planet = $(svg.circle(g, x, y, r1, {fill: 'blue', stroke: 'blue', strokeWidth: 3}))
    planet.addClass('planet')
      .data('hashs', hashs)
      .bind 'remove-all-satellites', ->
        console.log '>>remove-all-satellite'
        $(@).siblings().filter('.satellite').remove()
      .click ->
        console.log '>>click@20'
        $(@).data('hashs', $(@).data('hashs')+[{}])
      .bind 'add-satellite', (evt, hash) ->
        console.log '>>add-satellite, hash:', hash
        data_to_save = planet.data('hashs')
        data_to_save[_.max($('svg .satellite').map(-> $(@).data('index')))+1] = hash
        planet.data('hashs', data_to_save)
        planet.trigger('update.planet-input')
      .bind 'update.planet-input', ->
        console.log '>>update.planet-input'
        planet.trigger 'remove-all-satellites'
        hashs_ = $(@).data('hashs')
        if hashs_.length is 0
          return
        _.each hashs_, (hash, i) ->
          satellite = $(svg.circle(g, (x+r3*Math.cos(2*Math.PI*i/hashs_.length)),  (y+r3*Math.sin(2*Math.PI*i/hashs_.length)), r2, {fill: 'green', stroke: 'green', strokeWidth: 3}))
          satellite.addClass('satellite')
            .css('z-index', 3)
            .data('hash', hash)
            .data('index', i)
            .mouseover ->
              console.log '>>#mouseover'
              draw_area.append(
                $('<div/>').attr('id','satellite-tooltip')
                           .append($.obj2table($(@).data('hash')))
                           .css(position: 'absolute', top: $(@).attr('cy'), left: $(@).attr('cx'), 'z-index': 2, 'margin': '10px')
              )
            .mouseout ->
              console.log '>>#mouseout'
              $('#satellite-tooltip').remove()
            .click ->
              console.log '>>click'
              $('#satellite-editor').trigger('close.planet-input')
              wnd = $('<div id="satellite-editor"><form></form></div>')
                .css(
                   position: 'absolute',
                   display: 'block',
                   top: $(@).attr('cy'),
                   left: $(@).attr('cx'),
                   'z-index': 3,
                   'margin': '10px'
                )
                .click(-> false)
                .append($.obj2table($(@).data('hash'), edit: true))
                .append($('<button>Copy</button>')
                  .attr(id: 'satellite-editor-copy')
                  .click(-> satellite.trigger('copy.planet-input')))
                .append($('<button>Cancel</button>')
                  .attr(id: 'satellite-editor-cancel')
                  .click(-> wnd.trigger('close.planet-input')))
                .append $('<button>Ok</button>')
                  .attr(id: 'satellite-editor-ok')
                  .click ->
                    console.log ">> ok is clicked"
                    wnd.trigger('save.planet-input')
                    wnd.trigger('close.planet-input')
                .bind('close.planet-input', ->
                  console.log ">>close.planet-input"
                  $(@).remove())
                .bind('save.planet-input', ->
                  console.log ">>save.planet-input"
                  result = {}
                  $(@).find('input').each -> result[$(@).attr('name')] = $(@).val()
                  data_to_save = planet.data('hashs')
                  data_to_save[satellite.data('index')] = result
                  planet.data('hashs', data_to_save)
                  satellite.data('hash', result)
                  planet.trigger('update.planet-input'))
              draw_area.append(wnd)
              false
            .bind 'copy.planet-input', ->
              console.log '>>copy.planet_id'
              new_hash = $.extend({}, $(@).data('hash'))
              new_hash.id = _.max($('svg .satellite').map(-> $(@).data('hash').id)) + 1
              planet.trigger('add-satellite', [new_hash])
      .trigger('update.planet-input')
    results = []
    values_num = _.map($('#main').find('tr'), (e)-> $(e).find('td.value').length).max().first()
    _.range(0, values_num).each (i) ->
      result = {}
      $('.key').each ->
        j = $(@)
        k = j.children().val()
        v = j.siblings().filter("td.value").eq(i).children().val()
        lg k, v
        result[k] = v
      results = results.add(result)
    console.log(results)
    # $('#draw-area').trigger('add-planet', 100, 100, 20, 10, 5, hashs)


  $('#draw').click ->
    console.log '>>clicked'
    hashs_sample = [
      (id: 1, name: 'suzuki', age: 29),
      (id: 2, name: 'sato', age: 31),
    ]
    console.log $('#draw-area')
    $('#draw-area').trigger('add-planet', [200, 200, 30, 5, 100, 'planet1', hashs_sample])
    false

  $('#draw2').click ->
    console.log '>>clicked(2)'
    $('table').each ->
      self = $(@)
      planet_name = self.find('.planet-name').val()
      x = self.find('.x').val()*1
      y = self.find('.y').val()*1
      r = self.find('.r').val()*1
      hashs_sample = []
      td_num = self.find('td.key').has('input[value=id]').siblings('td.value').has('input[value!=""]').length
      console.log '>>td_num', td_num
      _.range(0, td_num).each (i) ->
        console.log '>>i', i
        hash_sample = {}
        self.find('td.key').each ->
          k = $(@).find('input').val()
          v = $(@).siblings('td.value').find('input').eq(i).val()
          hashs_sample[i] ?= {}
          hashs_sample[i][k] = v
      $('#draw-area').trigger('add-planet', [x, y, r, 5, 100, planet_name, hashs_sample])
    false

  $('#extract').click ->
    console.log '>>extract'
    console.log $('#draw-area').find('.planet:first').data('hashs')
    false

  $('#debug').click ->
    console.log '>>debug'
    s0 = $('#draw-area2').svg()
    s = $('#draw-area2').svg('get')
    c = s.circle(10, 20, 30, {fill: 'green', stroke: 'green', strokeWidth: 3})
    $(c).addClass('foo')
    false

  $('#to-matrix').click ->
    console.log ">>to-matrix"
    $('.planet').each (i)->
      $.each $(@).data('hashs'), (j)->
        $.each @, (k, v)->
          $('td.key').has('input[value='+k+']').siblings('td.value:nth-child('+(j+2)+')').find('input').eq(0).val(v)
