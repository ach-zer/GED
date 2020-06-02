import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { NzModalService } from 'ng-zorro-antd';

@Injectable({
  providedIn: 'root'
})
export class DocAnnotService {

  radioValue = "";
  TEXTANNO = "";
  tabTypeAnno = [];

  constructor(private http: HttpClient, private modal: NzModalService) { }

  selectTypesAnnotations() {

    this.tabTypeAnno = [];


    let gUrl = "http://localhost:8083/api/dc/of/annotation/types";

    this.http.get(gUrl).toPromise().then(resp => {

      let i = 0;
      let response = JSON.parse(JSON.stringify(resp)).data.typeAnno.data;
      console.log(response);

      for (i = 0; i < response.length; i++) {
        console.log(response[i]);
        this.tabTypeAnno.push(response[i]);
      }

    }).catch(resp => {console.log("error in request")});
  }

  insertDocAnnotation(IDEDOCBI, TEXTANNO, radioValue) {
    let gUrl = "http://localhost:8083/api/dc/of/doc/annotation";

    //let idedocbi = this.doc_all_service.ideCurrentDoc;
    
    var postData = {
      "CODETYPAN":  radioValue, //CODETYPAN
      "TEXTANNO":   TEXTANNO,
      "IDEDOCBI":   "" + IDEDOCBI
    };
    console.log(postData);

      this.http.post(gUrl, postData).subscribe(
        resp => {
          let data = JSON.parse(JSON.stringify(resp));
          console.log(data);
          this.radioValue = "";
          this.TEXTANNO = "";
          let modalMsg;
          modalMsg = this.modal.success({
                nzTitle: 'Le document a été bien annoté !',
          });
          setTimeout(() => modalMsg.destroy(), 3000);
        });
  }
}
