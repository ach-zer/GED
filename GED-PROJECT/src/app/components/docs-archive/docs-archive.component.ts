import { Component, OnInit, Input } from '@angular/core';
import { NzFormatEmitEvent, NzDropdownMenuComponent, NzContextMenuService, NzTreeNode, NzModalService } from 'ng-zorro-antd';
import { DocsArchiveService } from './docs-archive.service';

@Component({
  selector: 'app-docs-archive',
  templateUrl: './docs-archive.component.html',
  styleUrls: ['./docs-archive.component.css']
})
export class DocsArchiveComponent implements OnInit {

  t_nodes = [];
  isSpinning = false;

  isLoadingNC = false;
  isLoadingNT = false;

  STRUCT = "";
  isVisible = false;

  constructor(private docs_archive_service: DocsArchiveService) {
  }

  ngOnInit() {        
    this.docs_archive_service.selectArchives().subscribe(
      t_nodes => this.t_nodes = t_nodes);
  }

  loadNC(): void {
    this.isLoadingNC = true;
    setTimeout(() => {
      this.isLoadingNC = false;
    }, 1000);
  }

  loadNT(): void {
    this.isLoadingNT = true;
    setTimeout(() => {
      this.isLoadingNT = false;
    }, 1000);
  }

  showModal(): void {
    this.isVisible = true;
  }

  handleOk(): void {
    this.docs_archive_service.createArchive(this.STRUCT);
    this.isVisible = false;
  }

  handleCancel(): void {
    this.STRUCT = "";
    console.log('Button cancel clicked!');
    this.isVisible = false;
  }



  /* nzEvent(event: NzFormatEmitEvent): void {
    //console.log(event);
    this.modal.confirm({
      nzTitle: 'Voulez-vous classer ce document dans ce dossier ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {    
                          console.log(event.node.key);            
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        
                        }
    });
    //With 
  } */

  /* nodes = [
    {
      title: 'parent 0',
      key: '100',
      expanded: true,
      children: [
        { title: 'leaf 0-0', key: '1000', isLeaf: true },
        { title: 'leaf 0-1', key: '1001', isLeaf: true }
      ]
    },
    {
      title: 'parent 1',
      key: '101',
      children: [
        { title: 'leaf 1-0', key: '1010', isLeaf: true },
        { title: 'leaf 1-1', key: '1011', isLeaf: true }
      ]
    }
  ]; */
  
}