import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay } from "rxjs/operators";
import { NzModalService } from 'ng-zorro-antd';

@Injectable({
  providedIn: 'root'
})
export class DocsSearchService {

  constructor(private http: HttpClient, private modal: NzModalService) { }

  ideCurrentDoc = "";

  dataCard = [];
  MOT_CLE = "";

  isSpinning = false;
  isSearch = false;

  selectDocumentsIds(MOT_CLE): Observable<any>{

    this.load();

    if(MOT_CLE.length == "0"){
      return;
    }

    this.dataCard = [];
    
    let gUrl = "http://localhost:8083/api/dc/of/doc/motCle";
    let postData = {"MOT_CLE" : MOT_CLE};
    
    this.http.post(gUrl, postData).toPromise().then(resp => {
      let response = JSON.parse(JSON.stringify(resp)).data.ids;
      let response1 = JSON.parse(JSON.stringify(resp)).data.desdocs;
      console.log(response1);
      console.log(response);
      
      if(response.length > 1){  //If the response exists

           
            //Ids
            let response2 = "" + response + "";
            let response3 = response2.substring(0, response2.length - 1).split(',');

            //Names
            let response4 = "" + response1 + "";
            let response5 = response4.substring(0, response4.length - 1).split(',');

            for(let i = 0; i < response3.length;i++){
              if(response3[i] == "undefine"){
                return;
              }
              this.dataCard.push({ idedocbi: response3[i], desdocbi: response5[i] });
            }


            console.log(this.dataCard);

      }
    }).catch(resp => console.log("problème au serveur"));
    
    return of(this.dataCard).pipe(delay( 1500 ));

  }

  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }

  insertRefDoc(IDEDOCBI, tags){
    let gUrl = "http://localhost:8083/api/dc/of/doc/referencement";


    for (let i = 1; i < tags.length; i++) {
        let postData = {
            "IDEDOCBI"  :  ""+IDEDOCBI,
            "MOT_CLE"   :  tags[i]
          };

        this.http.post(gUrl, postData).subscribe(
          resp => {
            let data = JSON.parse(JSON.stringify(resp));
            console.log(data);
            tags = [];
            console.log("tags : "+tags);
            
            let modalMsg = this.modal.success({
              nzTitle: 'Le document a été référencé !',
            });
            setTimeout(() => modalMsg.destroy(), 3000);
        });
      
    }

  }

}
