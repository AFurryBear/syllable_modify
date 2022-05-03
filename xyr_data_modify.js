var express = require('express');
var path = require('path');
var cp  = require('child_process');
const fs = require('fs');
const multer = require('multer');
const upload = multer({ dest: 'data/' });
//var formidable = require('formidable');
var app = express();
app.use(express.static(path.join(__dirname, './')));
app.use(express.json());
app.use(express.text());

app.post("/submit_file", upload.fields([{
    name: 'umapCSV', maxCount: 1
}, {
    name: 'sylMAT', maxCount: 1
}]), (req, res) => {
    // Stuff to be added later

    var path_umap = req.files.umapCSV[0].path;
    var path_syl = req.files.sylMAT[0].path;
    console.log(path_umap);
    var cmd0 = 'python3 py/xyr_data_prepare.py ' +__dirname+'/'+path_umap+ ' '+__dirname+'/'+path_syl+' '+__dirname;
    console.log(cmd0)
    cp.exec(cmd0,(err,stdout) => {
        console.log('stdout', stdout);
        res.json({
            flag:'success',
            stdout:stdout,
        })

        //res.render('index.html');res.render('index.html');
        res.end();


    })
});

app.get('/download/*', (req, res) => {
    console.log(req.url)
    var url=req.url;
    var arr=url.split('/');
    var b = arr.splice(2);
    var file=b.join('/');
    if (typeof(file) !== undefined){
        console.log(file);
        var path = __dirname  + '/'+file;
        console.log(path);
        var size = fs.statSync(path).size;
        var f = fs.createReadStream(path);
        res.writeHead(200,{
            'Content-Type':'application/force-download',
            'Content-Disposition':'attachment;filename='+file,
            'Content-Length':size
        })
        f.pipe(res);
    }

})

app.get('/', function(req,res){
    res.render('index.html');
})
app.post('/modify_label',function(req,res){

    let data=JSON.parse(req.body);
    console.log(data);
    fs.writeFile('data/modify_log/'+data.fileIndex+'.json', req.body, (err) => {
        if (err) {
            throw err;
        }
        console.log("JSON data is saved.");

        var cmd = 'python3 py/xyr_modify_label.py ' +data.fileIndex+ ' '+__dirname;
        console.log(cmd);
        cp.exec(cmd,(err,stdout) => {
            if (err) {console.log('stderr', err)};
            if (stdout) {
                console.log('stdout', stdout);
                res.json({
                    flag:'success',
                    stdout:stdout,
                })
                res.end();
            };

        })


    });

}).listen(8080);