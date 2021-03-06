import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay } from "rxjs/operators";
import { NzModalService, NzFormatEmitEvent } from 'ng-zorro-antd';
import { DocsNcService } from '../docs-nc/docs-nc.service';

@Injectable({
  providedIn: 'root'
})
export class DocsArchiveService {


  dataCA = [];

  //personnes
  tabDesDoss = [];
  tabIdDoss = [];
  //compagnies
  tabDesDossCo = [];
  tabIdDossCo = [];

  tabLen = [];

  //data
  t_nodes = [];
  t_nodes_co = [];

  isSpinning = false;

  constructor(private http: HttpClient, private modal: NzModalService, 
        private docs_nc_service: DocsNcService) {
          //this.selectClassesArchives().subscribe(dataCA => this.dataCA = dataCA);
        }


  createArchive(STRUCT){
      let gUrl = "http://localhost:8083/api/dc/of/archive/create";

      let postData = {
        "STRUCT"  : STRUCT,
      }

     this.http.post(gUrl, postData).toPromise().then(resp => {
        let response = JSON.parse(JSON.stringify(resp));
        console.log(response);
        this.t_nodes = [];
        this.selectArchives();
        //this.docs_nc_service.selectDocumentsIds().subscribe(dataCard => this.docs_nc_service.dataCard = dataCard);
     });

  }

  selectArchives() : Observable<any> {

    this.load();

    this.tabDesDoss = [];
    this.tabIdDoss = [];
    this.t_nodes = [];

    this.tabDesDossCo = [];
    this.tabIdDossCo = [];
    this.t_nodes_co = [];
    
    let gUrl = "http://localhost:8083/api/dc/of/archives/ids";

    this.http.get(gUrl).toPromise().then(resp => {
  
      let response = JSON.parse(JSON.stringify(resp)).data.structures_archive.data;

      console.log(response);

      for(let i = 0; i < response.length;i++){
        for(let j = 0; j < 2;j++){

          if( j == 0 ){

            if(response[i][j].indexOf("#") == response[i][j].lastIndexOf("#")){
              console.log("id pers : "+response[i][j]); // It's for Ids
              this.tabIdDoss.push(response[i][j]);
            
            }else{
              console.log("id comp : "+response[i][j]); // It's for Ids
              this.tabIdDossCo.push(response[i][j]);
            }
            
          }
            
          if( j == 1 ){

            if(response[i][j].indexOf("#") == response[i][j].lastIndexOf("#")){
              console.log("des pers : "+response[i][j]); // It's for Des
              this.tabDesDoss.push(response[i][j]); 
            
            }else{
              console.log("des comp : "+response[i][j]); // It's for Des
              this.tabDesDossCo.push(response[i][j]); 
            }
            
          }

        }
      }

      let i;

      //compagnies
      for(i = 0 ; i < this.tabDesDossCo.length, i < this.tabIdDossCo.length ; i++){        
        this.selectArchivesWithDocs(this.tabDesDossCo[i], this.tabIdDossCo[i], i);
      }

      let j;
      //personnes
      for(j = 0 ; j < this.tabDesDoss.length, j < this.tabIdDoss.length ; j++){
          this.selectArchivesWithDocs(this.tabDesDoss[j], this.tabIdDoss[j], j); 
      }

      console.log(this.t_nodes);
      console.log(this.t_nodes_co);

    }).catch(resp => {
        console.log(" Problème au serveur ");
    });

    return of(this.t_nodes).pipe(delay( 2000 ));

    
  }

  selectArchivesWithDocs(des, iddos, i) {

    let gUrl = "http://localhost:8083/api/dc/of/docs/struArch";

          let postData = {"IDDOSS" : iddos};

          

          this.http.post(gUrl, postData).toPromise().then(resp => {

              let response = JSON.parse(JSON.stringify(resp)).data;
              let designation = ""+des+""
              let idendoss = ""+iddos+""
              

              if(idendoss.indexOf("#") == idendoss.lastIndexOf("#")){
                  // personne
                  this.t_nodes.push(
                    {
                      title: ""+des,
                      key: ""+iddos,
                      expanded: false,
                      children: []
                    }
                  );

                  console.log(iddos +":::"+ response.length);

                  let j;
          
                  for(j = 0 ; j < response.length ; j++){                         
                    console.log(response.children[j]);
                    this.t_nodes[i].children.push(response.children[j]);
                  }

              }else {
                  //compagnie
                  this.t_nodes_co.push(
                    {
                      title: ""+des,
                      key: ""+iddos,
                      expanded: false,
                      children: []
                    }
                  );

                  console.log(iddos +"co:::"+ response.length);

                  let j;
          
                  for(j = 0 ; j < response.length ; j++){                         
                    console.log(response.children[j]);
                    this.t_nodes_co[i].children.push(response.children[j]);
                  }
              }                                         
            
          });
  }

  classerDocument(idedocbi, idendoss){
     this.load();
     console.log(this.t_nodes);
     let gUrl = "http://localhost:8083/api/dc/of/doc/classer";

     let postData = {
        "IDEDOCBI"  : idedocbi,
        "IDDOSS"    : idendoss,
     }

     this.http.post(gUrl, postData).toPromise().then(resp => {
        let response = JSON.parse(JSON.stringify(resp));
        console.log(response);
        this.t_nodes = [];
        this.selectArchives();
        this.docs_nc_service.selectDocumentsIds().subscribe(dataCard => this.docs_nc_service.dataCard = dataCard);
     });

  }

  nzClassement(event: NzFormatEmitEvent): void {
    
    let index = event.node.key.indexOf('#');
    let modalMsg;

    if(index == -1){
        modalMsg = this.modal.error({
            nzTitle: 'Veuillez selectionner un archive non pas un document',
        });
        setTimeout(() => modalMsg.destroy(), 4000);
        return;      
    }

    else if(this.docs_nc_service.idedocbiSelected == 0 ){
          modalMsg = this.modal.error({
                nzTitle: 'Veuillez selectionner un document à classer!',
          });
          setTimeout(() => modalMsg.destroy(), 4000);
          return;
    }
  
    else if(index != -1){
          
          this.modal.confirm({
                nzTitle: 'Voulez-vous classer ce document dans ce dossier ?',
                nzOkText: 'Oui',
                nzOkType: 'primary',
                nzOnOk: () => {                               
                        let idendoss = ""+event.node.key+"";
                        console.log(idendoss);
                        console.log(this.docs_nc_service.idedocbiSelected);
                        this.classerDocument(this.docs_nc_service.idedocbiSelected, idendoss);
                        //this.docs_nc_service.selectDocumentsIds(); 
                              
                        modalMsg = this.modal.success({
                          nzTitle: 'Votre document a été classé !',
                        });
                        setTimeout(() => modalMsg.destroy(), 4000);
                        this.docs_nc_service.idedocbiSelected = 0;  
                        
                    },
                nzCancelText: 'Non',
                nzOnCancel: () => {
                        return;
                        }
          });
    }

    else{
            console.log("selectionner un archive");
            modalMsg = this.modal.warning({
                nzTitle: 'Veuillez selectionner un archive !',
            });
            setTimeout(() => modalMsg.destroy(), 5000);
    }

  }

  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }

  showMessage(){
    let modalMsg;
    modalMsg = this.modal.info({
      nzTitle: 'Pour classer un document, veuillez cliquer une fois sur le nom du document à classer puis vous cliquez sur le nom du dossier que vous choisissez.',
    });
    setTimeout(() => modalMsg.destroy(), 10000);
  }

  selectClassesArchives(): Observable<any> {

    this.dataCA = [];

    this.load();

    let gUrl = "http://localhost:8083/api/dc/of/classes/select";

    this.http.get(gUrl).toPromise().then(resp => {
      let data = JSON.parse(JSON.stringify(resp)).data.classes.data; // We must use the parse method to simplify
      console.log(resp);
      console.log(data);

      if(data.length == 0){
        return;
      }

      for (let i = 0 ; i < data.length ; i++){
        this.dataCA.push({
                            classe: data[i][0], 
                            initial: data[i][1], 
                            designation: data[i][2],
                            designationCourte: data[i][3]
        });
      }


    }).catch(resp => {
      console.log("Problème au serveur");
  });

    return of(this.dataCA).pipe(delay( 2000 ));
  }
  
}