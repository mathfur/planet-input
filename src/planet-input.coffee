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
  $('#draw-area').bind 'add-planet', (event, x, y, r1, r2, r3, hashs) ->
    draw_area = $(this)
    svg = $(this).find('svg:first')
    $(document.createElementNS('http://www.w3.org/2000/svg', 'circle'))
      .attr(cx: x, cy: y, r:r1)
      .data('hashs', hashs)
      .appendTo(svg)
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
        _.each hashs_, (hash, i) ->
          $(document.createElementNS('http://www.w3.org/2000/svg', 'circle'))
            .attr( cx: (x+r3*Math.cos(2*Math.PI*i/hashs_.length)), cy: (y+r3*Math.sin(2*Math.PI*i/hashs_.length)),  r: r2)
            .addClass('satellite')
            .appendTo(svg)
            .data('hash', hash)
            #.mouseover ->
            #  console.log '>>#mouseover'
            #  draw_area.append(
            #    $('<div/>').attr('id','satellite-tooltip')
            #               .append($.obj2table($(@).data('hash')))
            #               .css(position: 'absolute', top: $(@).attr('cy'), left: $(@).attr('cx'), 'z-index': 2, 'margin': '10px')
            #  )
            #.mouseout ->
            #  console.log '>>#mouseout'
            #  $('#satellite-tooltip').remove()
            .click ->
                console.log '>>click'
                wnd = $('<div><form></form></div>')
                  .css(position: 'absolute', top: $(@).attr('cy'), left: $(@).attr('cx'), 'z-index': 2, 'margin': '10px')
                  .append($.obj2table($(@).data('hash'), edit: true))
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
                draw_area.append(wnd)
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
      (name: 'suzuki', age: 29),
      (name: 'sato', age: 31),
    ]
    console.log $('#draw-area')
    $('#draw-area').trigger('add-planet', [200, 200, 30, 5, 100, hashs_sample])
    false
