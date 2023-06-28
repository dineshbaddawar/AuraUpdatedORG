({
    doInit : function(component, event, helper) {
        debugger;
        var params = {};
        helper.callToServer(
            component,
            "c.fetchAccountsForMap",
            function(response)
            { 
                console.log('apex response :'+JSON.stringify(response));
                var markers = [];
                for(var i=0; i < response.length; i++) {
                    var accountInfo = response[i];
                    var completeAddress=[];
                    
                    if(accountInfo.Geo_Location__Latitude__s){
                        completeAddress.push(accountInfo.Geo_Location__Latitude__s);
                    }if(accountInfo.Geo_Location__Longitude__s){
                        completeAddress.push(accountInfo.Geo_Location__Longitude__s);
                    }
                    
                    markers.push({
                        'location': {
                            'Latitude': accountInfo.Geo_Location__Latitude__s,
                            'Longitude': accountInfo.Geo_Location__Longitude__s
                        },
                        'icon': 'standard:account',
                        'title' : accountInfo.Name,
                        'description' : accountInfo.BillingStreet,
                        type: 'Circle',
                        radius: 200, 
                        strokeColor: '#FFF000', 
                        strokeOpacity: 0.8,
                        strokeWeight: 2,
                        fillColor: '#FFF000', 
                        fillOpacity: 0.35,
                    });
                    
                }
                console.log('****markers data-'+JSON.stringify(markers));
                component.set('v.markersTitle', 'All Account Locations');
                component.set('v.mapMarkers', markers);
            }, 
            params
        );	
    }
})