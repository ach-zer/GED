import { Component, OnInit } from '@angular/core';
import { AnnotationsDocService } from './annotations-doc.service';

@Component({
  selector: 'app-annotations-doc',
  templateUrl: './annotations-doc.component.html',
  styleUrls: ['./annotations-doc.component.css']
})
export class AnnotationsDocComponent implements OnInit {

  listOfData = [];

  constructor(private annotations_doc_service: AnnotationsDocService) { }

  ngOnInit() {
    this.annotations_doc_service.selectAnnotationsDoc().subscribe(dataAnno => this.listOfData = dataAnno);
  }

  

}
