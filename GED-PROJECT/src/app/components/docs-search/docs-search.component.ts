import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocsSearchService } from './docs-search.service';
import { DocTypService } from '../doc-typ/doc-typ.service';

@Component({
  selector: 'app-docs-search',
  templateUrl: './docs-search.component.html',
  styleUrls: ['./docs-search.component.css']
})
export class DocsSearchComponent implements OnInit {

  @ViewChild('pdfViewerOnDemand', { static: false }) pdfViewerOnDemand;
  @ViewChild('pdfViewerAutoLoad', { static: false }) pdfViewerAutoLoad;

  MOT_CLE = "";
  dataCard = [];
  isSpinning = false;
  isSearch = false;

  isVisible = false;
  selectedType = "";

  // Refe
  @ViewChild('inputElement', { static: false }) inputElement: ElementRef;
  isVisibleRefe = false;
  tags = ['Insérer mots clé'];
  inputVisible = false;
  inputValue = '';

  constructor(private http: HttpClient, private docs_search_service: DocsSearchService, 
    private doc_typ_service: DocTypService) {
    this.dataCard = [];
    this.MOT_CLE = "";
  }

  ngOnInit() {
    this.isSearch = false;
  }

  selectDocumentsIds(MOT_CLE) {
    
    if(MOT_CLE.length != 0){
      this.docs_search_service.selectDocumentsIds(MOT_CLE).subscribe(dataCard => this.dataCard = dataCard);
      this.isSearch = true;
    }
    
  }

  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }

  // By clic
  openPdf(idedocbi) {
    let gUrl = "http://localhost:8083/api/doc/select";

    console.log(idedocbi);

    if(idedocbi != undefined){
      let postData = { "idedocbi": idedocbi };
  
      var blob;
      this.http.get(gUrl, { params: { idedocbi: idedocbi }, responseType: 'blob' })
        .toPromise().then(resp => {
          
          blob = new Blob([resp], { type: 'application/pdf' });
          this.pdfViewerOnDemand.pdfSrc = blob;
          this.pdfViewerOnDemand.refresh();
          console.log(resp);
        }).catch(resp => console.log("Problème au serveur"));

    }else {
        console.log("idedocbi is undefined");
    }
    
  }

  showModal(idedocbi): void {
    console.log(idedocbi);
    this.docs_search_service.ideCurrentDoc = idedocbi;
    this.doc_typ_service.selectTypeDoc();
    this.isVisible = true;
  }

  onChangeTypes(selectedType: string) {
    console.log(selectedType);
    this.doc_typ_service.selectedType = selectedType;
    this.doc_typ_service.getIdTypeSelected();
    console.log(this.doc_typ_service.idSelectedType);
  }

  handleOk(): void {
    console.log('Button ok clicked!');
    this.doc_typ_service.updateTypeDoc(this.docs_search_service.ideCurrentDoc, this.selectedType, this.doc_typ_service.idSelectedType);
    this.isVisible = false;
  }

  handleCancel(): void {
    console.log('Button cancel clicked!');
    this.isVisible = false;
  }

  // Referencement
  showModalRefe(idedocbi): void {
    console.log(idedocbi);
    this.docs_search_service.ideCurrentDoc = idedocbi;
    this.isVisibleRefe = true;
  }


  handleOkRefe(): void {
    console.log("handle ok Refe");
    this.isVisibleRefe = false;
    this.docs_search_service.insertRefDoc(this.docs_search_service.ideCurrentDoc, this.tags)
  }


  handleCancelRefe(){
    console.log("handle cancel Refe");
    this.isVisibleRefe = false;
  }

  handleClose(removedTag: {}): void {
    this.tags = this.tags.filter(tag => tag !== removedTag);
  }

  sliceTagName(tag: string): string {
    const isLongTag = tag.length > 40;
    return isLongTag ? `${tag.slice(0, 40)}...` : tag;
  }

  showInput(): void {
    this.inputVisible = true;
    setTimeout(() => {
      this.inputElement.nativeElement.focus();
    }, 10);
  }

  handleInputConfirm(): void {
    if (this.inputValue && this.tags.indexOf(this.inputValue) === -1) {
      this.tags = [...this.tags, this.inputValue];
    }
    this.inputValue = '';
    this.inputVisible = false;
  }


}
