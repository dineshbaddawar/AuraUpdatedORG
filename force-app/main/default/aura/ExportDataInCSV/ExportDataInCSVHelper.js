({
	convertListToCSV : function(component, SobjectList) {
		debugger;
        if(SobjectList == null || SobjectList.length == 0){
            return null;
        }
        var columnEnd = ',';
        var lineEnd = '\n';
        var keys = new Set(); 
        SobjectList.forEach(function(record){
            Object.keys(record).forEach(function(key){
                if(component.get("v.ExportRecordWithId")){
                    keys.add(key);
                }else{
                    if(key!="Id")
                        keys.add(key);
                }
            });
        });
        keys = Array.from(keys); 
        var csvString = '';
        csvString += keys.join(columnEnd);
        csvString += lineEnd;
        for(var i=0;i<SobjectList.length;i++){
            var counter = 0;
            for(var sTempkey in keys){
                var skey = keys[sTempkey];
                if(counter >0){
                    csvString += columnEnd;
                }
                var value = SobjectList[i][skey] === undefined ? '' : SobjectList[i][skey];
                csvString += '"'+ value +'"';
                counter++; 
            }
            csvString += lineEnd;
            console.log("Data :::: ",csvString)
        }
        return csvString;
	},
    
    showToast:function(title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({"title": title,"type": type,"message": message}).fire();
        }
        else{
            alert(message);
        }
    },
})