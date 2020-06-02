import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class DocAcqService {

  files: File[] = [];
  idDocInserted: "0";
  docName: string;
  
  constructor() { }

}
