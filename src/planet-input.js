$(function(){

    // relative_elem :: ここを基準にabsolute座標を指定する
    // x, y :: 画用紙の配置位置
    // height, width :: 画用紙のサイズ
    var Gayoushi = function(relative_elem, x, y, height, width){
        this.relative_elem = $(relative_elem);
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.gayoshi_svg = $('<svg>gayoshi_svg</svg>');
        this.gayoshi_svg.css({
                position: 'absolute',
                'z-index': 2,
                background: 'rgba(0, 0, 50, 0.5)', 
                'border-radius': '5px',
                padding: 5, 
                'top': x,
                'left': y,
                width: width,
                height: height,
        });
        this.relative_elem.append(this.gayoshi_svg);
        console.log('__Gayoshi.initialize_END__');

        // マザーサークルを追加
        this.addMotherCircle = function(x1, y1, r){
                this.gayoshi_svg.append($('<circle></circle>').attr({cx:10, cy:10, r:10, fill:'blue'}));
                console.log('__Gayoshi.addMotherCircle_END__');
        }
    }
    
    //var gayoshi = new Gayoushi($('#container'), '10px', '10px', '600px', '400px');
    //gayoshi.addMotherCircle(100, 50, 10);

    // 要素は追加できるが、実際には描画されない
    // 推測原因
    //  * z-index :
    //  * visibility
    //  * display: block
    //  * 場所
    //$('#foo').append($('<circle></circle>').attr({cx:'20', cy:'20', r:'10', fill:'blue'}));
    //$('#foo').append($('<line></line>').attr({x1:'20', y1:'20', x2:'100',y2:'50', fill:'green', 'stroke-width':'4px'}));
    
    // 2012/01/05以降
    
    // 与える要素
    var SatelliteEditor = Class.create({
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        attrs: [],
        after: function(attars){ },
        initialize: function(universal, x, z, width, height){
                this.universal = universal;
                this.x = x;
                this.y = y;
                this.width = width;
                this.height = height;
                // table作成
                universal.append($("<table></table>")
                                .prepend($('<tr/>')
                                        .prepend($('<td/>').text('key1'))
                                        .prepend($('<td/>').text('val1'))
                                .prepend($('<tr/>')
                                        .prepend($('<td/>').text('key2'))
                                        .prepend($('<td/>').text('val2'))
                                        )
                                )
                                );
                // ,  ok, cancelボタン作成
        }
    });

    new SatelliteEditor($('#foo'), 100, 200, 50, 20);
    alert("__END__");
});
