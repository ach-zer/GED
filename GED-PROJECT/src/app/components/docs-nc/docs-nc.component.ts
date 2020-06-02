import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocsNcService } from './docs-nc.service';
import { DocTypService } from '../doc-typ/doc-typ.service';

@Component({
  selector: 'app-docs-nc',
  templateUrl: './docs-nc.component.html',
  styleUrls: ['./docs-nc.component.css']
})
export class DocsNcComponent implements OnInit {

  @ViewChild('pdfViewerOnDemand', { static: false }) pdfViewerOnDemand;
  @ViewChild('pdfViewerAutoLoad', { static: false }) pdfViewerAutoLoad;

  tabDocsIds = [];
  dataCard = [];
  isSpinning = false;
  isVisible = false;
  selectedType = "";

  constructor(private http: HttpClient, private docs_nc_service: DocsNcService, 
    private doc_typ_service: DocTypService) { 
    this.dataCard = [];
    this.selectedType = "";
  }

  ngOnInit() {
    this.getDocumentsNotClassified();
  }

  getDocumentsNotClassified(){
    this.docs_nc_service.selectDocumentsIds().subscribe(dataCard => this.dataCard = dataCard);
  }
  


  openPdf(idedocbi) {
    let gUrl = "http://localhost:8083/api/doc/select";

    console.log(idedocbi);

    let postData = { "idedocbi": idedocbi };
    
    this.http.get(gUrl, { params: { idedocbi: idedocbi }, responseType: 'blob' })
      .toPromise().then(resp => {
        var blob = new Blob([resp], { type: 'application/pdf' });
        this.pdfViewerOnDemand.pdfSrc = blob; // pdfSrc can be Blob or Uint8Array
        this.pdfViewerOnDemand.refresh(); // Ask pdf viewer to load/reresh pdf                            
        console.log(resp);
      });
  }
  
  saveIdedocbi(idedocbi){
    this.docs_nc_service.idedocbiSelected = idedocbi;
    console.log(this.docs_nc_service.idedocbiSelected);
  }

  showModal(idedocbi): void {
    this.docs_nc_service.idedocbiSelected = idedocbi;
    this.doc_typ_service.selectTypeDoc();
    this.isVisible = true;
  }

  onChangeTypes(selectedType: string) {
    console.log(selectedType);
    this.doc_typ_service.selectedType = selectedType;
    this.doc_typ_service.getIdTypeSelected();
    console.log(this.doc_typ_service.idSelectedType);
  }

  handleOk(IDEDOCBI): void {
    console.log('Button ok clicked!');
    this.doc_typ_service.updateTypeDoc(IDEDOCBI,this.selectedType, this.doc_typ_service.idSelectedType);
    this.isVisible = false;
  }

  handleCancel(): void {
    console.log('Button cancel clicked!');
    this.isVisible = false;
  }

}
