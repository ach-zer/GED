import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { delay } from "rxjs/operators";

@Injectable({
  providedIn: 'root'
})
export class DocsNcService {

  tabDocsIds = [];
  dataCard   = [];
  idedocbiSelected = 0;
  isSpinning = false;

  constructor(private http: HttpClient) { }

  selectDocumentsIds(): Observable<any> {
    
    this.tabDocsIds = [];
    this.dataCard = [];

    this.load();

    let gUrl = "http://localhost:8083/api/dc/of/docs/nonClasse"; // Just Ids

    this.http.get(gUrl).toPromise().then(resp => {
        let response = JSON.parse(JSON.stringify(resp)).data.ids;
        let response1 = JSON.parse(JSON.stringify(resp)).data.desdocs;

        console.log(response);

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

    }).catch(resp => console.log("problème au serveur"));

    return of(this.dataCard).pipe(delay( 2000 ));
  }

  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }

}
