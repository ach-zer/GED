import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class DocCaraService {

  formCaraValues = new FormData();
  typeCaraToUse: string[] = [];
  typeCodeCara: string[] = [];
  tabCodeAndValueCara: string[] = []; 

  constructor(private http: HttpClient) {}
  
  insertCaraDoc(IDEDOCBI){

      let gUrl = "http://localhost:8083/api/dc/of/doc/caracterisation";

      this.tabCodeAndValueCara.forEach(element => {   
        let LIBECARA = element.substring(0, element.indexOf("."));
        let CODECARA = element.substring(element.indexOf(".")+1);
        let postData = {
            "IDEDOCBI"  :  ""+IDEDOCBI,
            "LIBECARA"  :  ""+LIBECARA,
            "CODECARA"  :  CODECARA
        };
        
      this.http.post(gUrl, postData).subscribe(resp => {
          let data = JSON.stringify(resp);
          console.log(data);
          this.tabCodeAndValueCara = [];
        });
    });
}


}
