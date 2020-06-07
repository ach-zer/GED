import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { HttpClient } from '@angular/common/http';
import { NzModalService } from 'ng-zorro-antd';

@Injectable({
  providedIn: 'root'
})
export class ClasseArchivesService {

  isSpinning = false;
  dataCA = [];

  constructor(private http: HttpClient, private modal: NzModalService) { }

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

  createClasseArchive(NOM_CLASSE_ARCH){

    console.log(NOM_CLASSE_ARCH);

    let gUrl = "http://localhost:8083/api/dc/of/classe/create";

    let postData = {"DESCLAAR" : NOM_CLASSE_ARCH};

    this.modal.confirm({
      nzTitle: 'Voulez-vous créer cette classe saisie ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {
                        this.http.post(gUrl, postData).toPromise().then(
                          resp => {
                            let response = JSON.parse(JSON.stringify(resp)).data.message;
                            console.log(response);
                            let modalResult;

                            let response1 = ""+response+"";

                            console.log(response1);

                            if(response1.toString() == "created"){
                                  modalResult = this.modal.success({
                                    nzTitle: 'La classe a été créée avec succés',
                                  });
                                  this.selectClassesArchives().subscribe(dataCA => this.dataCA = dataCA);
                                  setTimeout(() => modalResult.destroy(), 3000);
                                  return;
                            }else{
                                  modalResult = this.modal.error({
                                    nzTitle: 'La classe n a pas été créée',
                                  });
                                  setTimeout(() => modalResult.destroy(), 3000);
                                  return;
                            }                
                          }).catch(resp => {
                              console.log("Problème au serveur");
                          });
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                          return;
                        }
    });

  }

  deleteClasseArchive(IDECLAAR){

    console.log(IDECLAAR);

    let gUrl = "http://localhost:8083/api/dc/of/classe/delete";
    let postData = {"IDECLAAR" : ""+IDECLAAR};

    this.modal.confirm({
      nzTitle: 'Voulez-vous supprimer cette classe ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {
                          this.http.post(gUrl, postData).toPromise().then(
                            resp => {
                              let response = JSON.parse(JSON.stringify(resp)).data.message;
                              console.log(response);
                              //this.selectClassesArchives();
                              let modalResult;
                              let response1 = ""+response+"";

                              if(response1.toString() == "deleted"){                              
                                  modalResult = this.modal.success({
                                    nzTitle: 'La classe a été supprimée avec succés',
                                  });
                                  this.selectClassesArchives().subscribe(dataCA => this.dataCA = dataCA);
                                  setTimeout(() => modalResult.destroy(), 3000);
                                  return;
                              }else{
                                  modalResult = this.modal.error({
                                    nzTitle: 'La classe n a pas été supprimée',
                                  });
                                  setTimeout(() => modalResult.destroy(), 3000);
                              }

                            }).catch(resp => {
                               console.log("Problème au serveur");
                          });                 
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                          return;
                        }
    });  

  }


  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }


}
