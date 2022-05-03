var all_color = ["#F0A3FF","#0075DC","#993F00","#4C005C","#191919","#005C31","#2BCE48","#FFCC99",
    "#808080","#94FFB5","#8F7C00","#9DCC00","#C20088","#003380","#FFA405","#FFA8BB","#426600","#FF0010",
    "#5EF1F2","#00998F","#E0FF66","#740AFF","#990000","#FFFF80","#FFFF00","#FF5005"];

var fileIndex = '0000';

var select_one = false;



var umap_option = {
    legend: {
        orient:'vertical',
        right: '5%',
        bottom: '2%',
    },
    dataZoom:[
        {
            type: 'inside'
        },
        {
            type: 'slider',
            showDataShadow: false,
            handleSize: '75%'
        },
        {
            type: 'inside',
            orient: 'vertical'
        },
        {
            type: 'slider',
            orient: 'vertical',
            showDataShadow: false,
            handleSize: '75%'
        }
    ],
    brush: {
        toolbox: ['rect', 'polygon', 'keep', 'clear'],
        xAxisIndex: 'none',
        inBrush:{
            color:'yellow',
        },
        outOfBrush:{
            color:'grey',
        }
    },
    title: {
        text: 'click to download UMAP result',
        left: '5%',
        top: '3%',
        triggerEvent: true
    },

    grid: {
        left: '5%',
        top: '10%',
        right:'15%'
    },
    xAxis: {
        splitLine: {
            lineStyle: {
                type: 'dashed'
            }
        }
    },
    yAxis: {
        splitLine: {
            lineStyle: {
                type: 'dashed'
            }
        },
        scale: true
    },

};

$.get('data/umap/umap_combine_'+fileIndex+'.json',function(data){
    var oridata=data.series;
    var leg_data = new Array();
    var color = new Array();
    for(var i=0;i<oridata.length;i++){
        leg_data.push(oridata[i].name);
        color.push(all_color[i]);
    }
    console.log(leg_data)
    umap_option.color=color;
    umap_option.legend.data=leg_data;
    umap_option.series=oridata;
    // Display the chart using the configuration items and data just specified.
    UMAP.setOption(umap_option);

    function upload_json(dataIndex){
        console.log(dataIndex)
        console.log('uploading')
        var settings = {
            "url": "/modify_label",
            "type": "POST",
            "headers": {
                "Content-Type": "text/plain"
            },
            "data": JSON.stringify({"dataIndex":dataIndex,"givenLabel": $("#given_label").val(),"fileIndex":fileIndex}),
            "success": function (data) {
                console.log("over..");
                console.log(data);
            },
            "beforeSend": function () {
            },
        };
        $.ajax(settings).done(function (response) {
            console.log(response);
            fileIndex = response.stdout.substr(0,4);
            $.get('data/umap/umap_combine_'+fileIndex+'.json',function(data) {
                var oridata = data.series;
                var leg_data = new Array();
                for (var i = 0; i < oridata.length; i++) {
                    leg_data.push(oridata[i].name)
                }
                umap_option.legend.data = leg_data;
                umap_option.series = oridata;
                // Display the chart using the configuration items and data just specified.
                UMAP.setOption(umap_option);
            });

            var div_label = document.getElementById('changeLabel');
            div_label.innerHTML="";
            div_label.style.visibility="hidden";
        })

    }



    function zoom_out(){
        UMAP.dispatchAction({
            type: 'dataZoom',
            // optional; index of dataZoom component; useful for are multiple dataZoom components; 0 by default
            dataZoomIndex: 1,
            // percentage of starting position; 0 - 100
            start: 0,
            // percentage of ending position; 0 - 100
            end: 100,
        });
        UMAP.dispatchAction({
            type: 'dataZoom',
            // optional; index of dataZoom component; useful for are multiple dataZoom components; 0 by default
            dataZoomIndex: 2,
            // percentage of starting position; 0 - 100
            start: 0,
            // percentage of ending position; 0 - 100
            end: 100,
        })
    }
    function select_only(params){
        for (var i = 0; i < umap_option.legend.data.length; i++) {
            UMAP.dispatchAction({type:'legendUnSelect',
                name:umap_option.legend.data[i]})
        }
        UMAP.dispatchAction({type:'legendSelect',
            name:params.seriesName});
        select_one = true;
    };

    function select_all(){
        for (var i = 0; i < umap_option.legend.data.length; i++) {
            UMAP.dispatchAction({type:'legendSelect',
                name:umap_option.legend.data[i]})
        }
        select_one = false;
    }

    function set_syl(syllabus,fname,callback){
        var syl_option = {

            grid: {
                left: '10%',
                top: '10%'
            },
            tooltip: {},
            xAxis: {
                type: 'category',
                show:false,
            },
            yAxis: {
                type: 'category',
                show:false,
            },
            visualMap: {
                show:false,
                orient:'horizontal',
                calculable: true,
                realtime: false,
                inRange: {
                    color: [
                        '#313695',
                        '#4575b4',
                        '#74add1',
                        '#abd9e9',
                        '#e0f3f8',
                        '#ffffbf',
                        '#fee090',
                        '#fdae61',
                        '#f46d43',
                        '#d73027',
                        '#a50026'
                    ]
                }
            },
            series: [
                {
                    name: 'syllabus',
                    type: 'heatmap',
                    emphasis: {
                        itemStyle: {
                            borderColor: '#333',
                            borderWidth: 1
                        }
                    },
                    progressive: 1000,
                    animation: false
                }
            ]
        };
        syllabus.setOption(syl_option);
        callback(fname,syl_option);
    }

    function changeSeries_label(params,callback){
        console.log(params.seriesName)
        console.log(umap_option.legend)
        var dataIndex = new Array();
        for (var i = 0; i < umap_option.legend.data.length; i++) {
            if (umap_option.legend.data[i]===params.seriesName){
                console.log(params.seriesIndex);
                console.log([...new Array(umap_option.series[params.seriesIndex].data.length).keys()]);
                var data = {'seriesName':umap_option.legend.data[i],"dataIndex":[...new Array(umap_option.series[params.seriesIndex].data.length).keys()]};
            }else{
                var data = {'seriesName':umap_option.legend.data[i],"dataIndex":[]}
            }
            dataIndex.push(data)
        }
        callback(dataIndex);
    }

    function label_panel(event,callback){
        //callback: SUBMIT post function
        var input_box = "<div id=\"input_label\">" +
            "  <label for=\"fname\">Label name</label>" +
            "  <input type=\"text\" id=\"given_label\" name=\"fname\" style=\"width: 100px\"><br><br>\n" +
            "  <input type=\"submit\" id=\"upload_label\" value=\"Submit\">\n" +
            "</div>";
        let delimg = document.createElement("img");
        delimg.id="del_img";
        delimg.src="close-window.png";
        delimg.style.position = "absolute";
        delimg.style.left = '0px';
        delimg.style.top = '0px';
        delimg.width=10;
        delimg.onclick=function(){console.log('test');console.log(this.parentElement);this.parentElement.style.visibility='hidden'};
        var div_label = document.getElementById('changeLabel');
        div_label.innerHTML="";
        div_label.style.position = "absolute";
        div_label.style.left = event.clientX+'px';
        div_label.style.top = event.clientY+'px';
        var createDiv=document.createElement("div");
        createDiv.innerHTML=input_box;
        document.getElementById('changeLabel').appendChild(createDiv);
        document.getElementById('changeLabel').appendChild(delimg);
        div_label.style.visibility="visible";
        console.log('runed panel')
        callback();
    };

    function show_syllable(params){
        let len = document.getElementsByName('syllabus').length;
        let div_syllabus = document.createElement("div");
        let id = "syllabus_"+String(len);
        div_syllabus.innerHTML="<div id=\""+id+"\" name=\"syllabus\" style=\"width: 150px;height:300px;float:left \"></div>";
        document.body.appendChild(div_syllabus);
        let delimg = document.createElement("img");
        delimg.id="del_"+id;
        delimg.src="close-window.png";
        delimg.style.position = "absolute";
        let xpos = Number(params.event.event.offsetX)+140;
        delimg.style.left = xpos+'px';
        delimg.style.top = params.event.event.offsetY+'px';
        delimg.width=10;
        delimg.onclick=function(){console.log('test');console.log(this.parentElement);this.parentElement.style.visibility='hidden'};
        div_syllabus.appendChild(delimg);


        let div = document.getElementById(id);
        div.style.position = "absolute";
        div.style.left = params.event.event.offsetX+'px';
        div.style.top = params.event.event.offsetY+'px';
        console.log(params.event.event.offsetX)

        var syllabus = echarts.init(document.getElementById(id));

        let fname = 'data/syllabus/syllabus_'+String(params.data[3]).padStart(5, "0")+'.json';
        set_syl(syllabus,fname,function(fname, syl_option){
            $.get(fname,function(data){
                console.log(data);
                var xData=[];
                var yData=[];
                var syl_data = [];
                for (var i = 0; i < data.data.length; i++) {
                    xData.push(i);
                    for (var j = 0; j < data.data[0].length; j++) {
                        syl_data.push([i, j, data.data[i][j]]);
                    }
                }
                for (var j = 0; j < data.data[0].length; j++) {
                    yData.push(j);
                }
                syl_option.series[0].name = 'syllabus_'+String(params.data[3]).padStart(5, "0");
                syl_option.series[0].data = syl_data;
                syl_option.xAxis.data = xData;
                syl_option.yAxis.data = yData;
                syllabus.setOption(syl_option);
            })
        });
    }

    UMAP.on('brushSelected', function (params) {
        $("#main").dblclick(function (event){


            if(event.shiftKey && event.ctrlKey){
                console.log('selected_data')
                label_panel(event,function(){
                    $("#upload_label").click(function () {
                        upload_json(params.batch[0].selected)
                    })
                })
            }
        })
    });


    UMAP.on('click',function (params){
        if(params.componentType === 'title') {
            console.log('click on title')
            $.ajax({
                type: 'GET',
                url: '/download/' + 'data/umap/umap_combine_' + fileIndex + '.csv',
                success: function () {
                    window.open('/download/' + 'data/umap/umap_combine_' + fileIndex + '.csv')
                },
            });
        }else if(params.componentType === 'series' && params.event.event.shiftKey && params.event.event.ctrlKey){
            console.log('selected_data')
            select_only(params);
            label_panel(params.event.event,function(){
                console.log(params.event.event)
                changeSeries_label(params,function(dataIndex){
                    $("#upload_label").click(function () {

                        upload_json(dataIndex)
                    })
                })
            });
        }else if(params.componentType === 'series' && params.event.event.shiftKey){
            console.log('show syllable')
            show_syllable(params)
        }else if(params.componentType === 'series' && params.event.event.ctrlKey){
            console.log('selected syllable range')
            if (select_one) {
                select_all();

            } else {
                select_only(params);

            }
        }else{
            console.log('zoom out')
            zoom_out()
        }
    })






});






