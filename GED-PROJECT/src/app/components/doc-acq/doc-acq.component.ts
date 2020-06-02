import { Component, OnInit } from '@angular/core';
import { DocAcqService } from './doc-acq.service';
import { NzMessageService, NzModalService } from 'ng-zorro-antd';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-doc-acq',
  templateUrl: './doc-acq.component.html',
  styleUrls: ['./doc-acq.component.css']
})
export class DocAcqComponent implements OnInit {

  files: File[] = [];
  nzDelay = 3000;
  nextStep = false; //To pass to the next step

  constructor(private doc_acqService: DocAcqService,
    private message: NzMessageService,private modal: NzModalService, private router: Router) {
      this.files = [];
      this.doc_acqService.files = [];
     }

  ngOnInit() {
  }

  onSelect(event) {
    
    console.log(event.addedFiles);
    this.files.push(...event.addedFiles);
    if (this.files[0].type != 'application/pdf') {
      this.message.error('Only PDF files are accepted', {
        nzDuration: 3000
      });
      this.files.splice(this.files.indexOf(event), 1);
      return;
    }
    else {
      this.message.success('Your file was uploading successfully', {
        nzDuration: 3000
      });
      this.nextStep = true;
    }
    this.doc_acqService.files.push(...event.addedFiles); // to save the data in the class service
    this.doc_acqService.docName = this.files[0].name.substring(0, this.files[0].name.indexOf("."));
    console.log(this.doc_acqService.docName);
  }

  isFileHere(){
    
    if(this.files.length < 1){
      let modalSuccess;
      /* this.modal.info({
        nzTitle: 'Veuillez selectionner un document !',
        nzOkText: 'Ok',
        //nzOnOk: () => console.log('Info OK')
      }); */
      modalSuccess = this.modal.success({
        nzTitle: 'Veuillez selectionner un document !',
        nzOkText: 'Ok',
      });
      setTimeout(() => modalSuccess.destroy(), 3000);
    }else{
      this.router.navigateByUrl("/api/ged/fiche");
    }
  }

  onRemove(event) {
    console.log(event);
    this.files.splice(this.files.indexOf(event), 1);
    this.doc_acqService.files.splice(this.doc_acqService.files.indexOf(event), 1);
  }
}
