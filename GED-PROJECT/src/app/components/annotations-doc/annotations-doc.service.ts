import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocsAllService } from '../docs-all/docs-all.service';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AnnotationsDocService {

  constructor(private http: HttpClient, private docs_all_service: DocsAllService) { }

  isSpinning = false;
  designation = "";
  dataAnno = [];
 
  selectAnnotationsDoc(): Observable<any> {

    this.designation = "";
    this.dataAnno = [];

    this.load();

    let gUrl = "http://localhost:8083/api/dc/of/docs/annotations";

    let postData = { "IDEDOCBI" : this.docs_all_service.ideCurrentDoc}

    this.http.post(gUrl, postData).subscribe(resp => {
      let data = JSON.parse(JSON.stringify(resp)).data.annoDocs.data; // We must use the parse method to simplify
      console.log(data);

      if(data.length == 0){
        return;
      }

      this.designation = data[0][0];

      for (let i = 0 ; i < data.length ; i++){
        this.dataAnno.push({annotation: data[i][1], date: data[i][2], type: data[i][3]});
      }
    
    });

    return of(this.dataAnno).pipe(delay( 2000 ));
  }

  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }
}
