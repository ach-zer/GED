import { Component, OnInit } from '@angular/core';
import { ClasseArchivesService } from './classe-archives.service';

@Component({
  selector: 'app-classe-archives',
  templateUrl: './classe-archives.component.html',
  styleUrls: ['./classe-archives.component.css']
})
export class ClasseArchivesComponent implements OnInit {

  constructor(private classe_archive_service: ClasseArchivesService) { }

  listOfData = [];

  ngOnInit() {
    this.classe_archive_service.selectClassesArchives().subscribe(dataCA => this.listOfData = dataCA);
  }



}
