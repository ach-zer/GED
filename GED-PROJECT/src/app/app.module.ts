import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { IconsProviderModule } from './icons-provider.module';
import { NgZorroAntdModule, NZ_I18N, fr_FR } from 'ng-zorro-antd';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { registerLocaleData } from '@angular/common';
import fr from '@angular/common/locales/fr';
import { NzFormModule } from 'ng-zorro-antd/form';
import { DocAcqComponent } from './components/doc-acq/doc-acq.component';
import { NgxDropzoneModule } from 'ngx-dropzone';
import { DocFicheComponent } from './components/doc-fiche/doc-fiche.component';
import { DocTypCaraComponent } from './components/doc-typ/doc-typ-cara.component';
import { DocCaraComponent } from './components/doc-cara/doc-cara.component';
import { DocRefComponent } from './components/doc-ref/doc-ref.component';
import { NzTagModule } from 'ng-zorro-antd/tag';
import { NzIconModule } from 'ng-zorro-antd/icon';
import { NzProgressModule } from 'ng-zorro-antd/progress';
import { NzMessageModule } from 'ng-zorro-antd/message';
import { NzTreeModule } from 'ng-zorro-antd/tree';
import { DocIdenComponent } from './components/doc-iden/doc-iden.component';
import { NzResultModule } from 'ng-zorro-antd/result';
import { NzDatePickerModule } from 'ng-zorro-antd/date-picker';
import { DocsAllComponent } from './components/docs-all/docs-all.component';
import { PdfJsViewerModule } from 'ng2-pdfjs-viewer';
import { NzModalModule } from 'ng-zorro-antd/modal';
import { DocsSearchComponent } from './components/docs-search/docs-search.component';
import { NzListModule } from 'ng-zorro-antd/list';
import { NzSpinModule } from 'ng-zorro-antd/spin';
import { DocsArchiveComponent } from './components/docs-archive/docs-archive.component';
import { DocAnnotComponent } from './components/doc-annot/doc-annot.component';
import { DocsNtComponent } from './components/docs-nt/docs-nt.component';
import { DocsNcComponent } from './components/docs-nc/docs-nc.component';
import { AnnotationsDocComponent } from './components/annotations-doc/annotations-doc.component';
import { NzDescriptionsModule } from 'ng-zorro-antd/descriptions';
import { NzAvatarModule } from 'ng-zorro-antd/avatar';
import { NzTableModule } from 'ng-zorro-antd/table';

registerLocaleData(fr);

@NgModule({
  declarations: [
    AppComponent,
    DocAcqComponent,
    DocFicheComponent,
    DocTypCaraComponent,
    DocCaraComponent,
    DocRefComponent,
    DocIdenComponent,
    DocsAllComponent,
    DocsSearchComponent,
    DocsArchiveComponent,
    DocAnnotComponent,
    DocsNtComponent,
    DocsNcComponent,
    AnnotationsDocComponent,
  ],
  imports: [
    AppRoutingModule,
    IconsProviderModule,
    NgZorroAntdModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    NzFormModule,
    ReactiveFormsModule,
    NgxDropzoneModule,
    NzTagModule,
    NzIconModule,
    NzProgressModule,
    NzMessageModule,
    NzTreeModule,
    NzResultModule,
    NzDatePickerModule,
    PdfJsViewerModule,
    NzModalModule,
    NzListModule,
    NzSpinModule,
    NzDescriptionsModule,
    NzAvatarModule,
    NzTableModule
  ],
  providers: [{ provide: NZ_I18N, useValue: fr_FR }],
  bootstrap: [AppComponent]
})
export class AppModule {}
