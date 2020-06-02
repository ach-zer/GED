import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class DocRefService {

  tabKeyWordsDoc: string[] = []; //To save our Keywords

  constructor(private http: HttpClient) { }

  insertRefDoc(IDEDOCBI){
    let gUrl = "http://localhost:8083/api/dc/of/doc/referencement";

    this.tabKeyWordsDoc.forEach(MOT_CLE => {
          let postData = {
                "IDEDOCBI"  :  ""+IDEDOCBI,
                "MOT_CLE"   :  MOT_CLE
          };

          this.http.post(gUrl, postData).subscribe(
            resp => {
              let data = JSON.parse(JSON.stringify(resp));
              console.log(data)
              this.tabKeyWordsDoc = [];
            });
      });
  }

}
