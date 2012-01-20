# TODO: <g>を加える
# 最初のトリガー部分
# tdテーブル

console.log('>>13:21');
$ ->
  lg = console.log
  $.obj2table = (obj) ->
      inner = $.map(obj, (k, v) -> "<tr><td>#{k}</td><td>#{v}</td></tr>")
      $("<table>#{inner}</table>")
  $('#draw-area').bind 'add-planet', (event, x, y, r1, r2, r3, hashs) ->
    console.log '>>add-planet'
    console.log(event, x, y, r1, r2, r3, hashs)
    $(document.createElementNS('http://www.w3.org/2000/svg', 'circle'))
      .attr(cx: x, cy: y, r:r1)
      .data('hashs', hashs)
      .bind 'remove-all-satellites', ->
        console.log '>>remove-all-satellite'
        $(@).siblings().filter('.satellite').remove()
      .click ->
        console.log '>>click@20'
        $(@).data('hashs', $(@).data('hashs')+[{}])
      .bind 'update.planet-input', ->
        console.log '>>update.planet-input'
        hashs_ = $(@).data('hashs')
        if hashs_.length is 0
          return
        _.each hashs_, (hash) ->
          $(document.createElementNS('http://www.w3.org/2000/svg', 'circle'))
            .attr( cx: (x+r3*Math.cos(2*Math.PI*i/hashs_.length)), cy: (y+r3*Math.sin(2*Math.PI*i/hashs_.length)),  r: r2)
            .addClass('satellite')
            .mouseover ->
              console.log '>>#mouseover'
              $('#draw-area').append(
                $('<div/>').attr('id','satellite-tooltip')
                           .append($.obj2table($(@).data('hash')))
                           .css(position: 'absolute', top: $(@).attr('cx'), left: $(@).attr('cy'), 'z-index': 2)
              )
            .mouseout ->
              console.log '>>#mouseout'
              $('#satellite-tooltip').remove()
            .click ->
                wnd = $('<div><form></form></div>')
                  .append($.obj2table($(@).data('hash')))
                  .append $('<button/>')
                    .attr(id: 'satellite-editor-cancel')
                    .click -> wnd.trigger('close.planet-input')
                  .append $('<button/>')
                    .attr(id: 'satellite-editor-ok')
                    .click ->
                      wnd.trigger('save.planet-input')
                      wnd.trigger('close.planet-input')
                  .bind 'close.planet-input', -> $(@).remove()
                  .bind 'save.planet-input', ->
                    result = {}
                    $(@).find('input').each -> result[$(@).name] = $(@).val()
                    circle.data('hashs', circle.data('hashs')+[result])
                    circle.trigger('upload.planet-input')
      .trigger('update.planet-input')
    results = []
    values_num = _.map($('#main').find('tr'), (e)-> $(e).find('td.value').length).max().first()
    _.range(0, values_num).each (i) ->
      result = {}
      $('.key').each () ->
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
      (name: 10, age: 29),
      (name: 12, age: 31),
    ]
    console.log $('#draw-area')
    $('#draw-area').trigger('add-planet', [100, 100, 20, 10, 5, hashs_sample])
    false
