import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocsNtService } from './docs-nt.service';
import { DocTypService } from '../doc-typ/doc-typ.service';
import { DocAnnotService } from '../doc-annot/doc-annot.service';

@Component({
  selector: 'app-docs-nt',
  templateUrl: './docs-nt.component.html',
  styleUrls: ['./docs-nt.component.css']
})
export class DocsNtComponent implements OnInit {

  @ViewChild('pdfViewerOnDemand', { static: false }) pdfViewerOnDemand;
  @ViewChild('pdfViewerAutoLoad', { static: false }) pdfViewerAutoLoad;

  tabDocsIds = [];
  dataCard = [];
  

  isVisible = false;
  selectedType = "";

  isVisibleAnno = false;
  radioValue = "";
  TEXTANNO = "";

  // Refe
  @ViewChild('inputElement', { static: false }) inputElement: ElementRef;
  isVisibleRefe = false;
  tags = ['Insérer mots clé'];
  inputVisible = false;
  inputValue = '';

  constructor(private http: HttpClient, private docs_nt_service: DocsNtService, 
    private doc_typ_service: DocTypService, private doc_anno_service: DocAnnotService) {
      this.TEXTANNO = "";
      this.radioValue = "";
      this.selectedType = "";
      this.tabDocsIds = [];
      this.dataCard = [];
  }

  ngOnInit() {
    this.getDocumentsNotTyped();
  }

  getDocumentsNotTyped(){
    this.docs_nt_service.selectDocumentsIds().subscribe(dataCard => this.dataCard = dataCard);// Just Ids
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

  showModalAnno(): void {
    this.doc_anno_service.selectTypesAnnotations();
    this.isVisibleAnno = true;
  }

  handleOkAnno(IDEDOCBI): void {
    console.log('Button ok clicked!');
    this.doc_anno_service.insertDocAnnotation(IDEDOCBI, this.TEXTANNO, this.radioValue);
    this.isVisibleAnno = false;
  }

  handleCancelAnno(): void {
    console.log('Button cancel clicked!');
    this.isVisibleAnno = false;
  }




  showModal(idedocbi): void {
    this.docs_nt_service.idedocbiSelected = idedocbi;
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
    this.dataCard = [];
    this.docs_nt_service.insertTypeDoc(this.docs_nt_service.idedocbiSelected, this.selectedType, this.doc_typ_service.idSelectedType);
    this.isVisible = false;
  }

  handleCancel(): void {
    console.log('Button cancel clicked!');
    this.isVisible = false;
  }

  // Referencement
  showModalRefe(idedocbi): void {
    console.log(idedocbi);
    this.docs_nt_service.idedocbiSelected = idedocbi;
    this.isVisibleRefe = true;
  }


  handleOkRefe(): void {
    console.log("handle ok Refe");
    this.isVisibleRefe = false;
    this.docs_nt_service.insertRefDoc(this.docs_nt_service.idedocbiSelected, this.tags)
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
