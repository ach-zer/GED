import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DocAcqComponent } from './components/doc-acq/doc-acq.component';
import { DocFicheComponent } from './components/doc-fiche/doc-fiche.component';
import { DocTypCaraComponent } from './components/doc-typ/doc-typ-cara.component';
import { DocCaraComponent } from './components/doc-cara/doc-cara.component';
import { DocRefComponent } from './components/doc-ref/doc-ref.component';
import { DocIdenComponent } from './components/doc-iden/doc-iden.component';
import { DocsAllComponent } from './components/docs-all/docs-all.component';
import { DocsSearchComponent } from './components/docs-search/docs-search.component';
import { DocsArchiveComponent } from './components/docs-archive/docs-archive.component';
import { DocAnnotComponent } from './components/doc-annot/doc-annot.component';
import { DocsNtComponent } from './components/docs-nt/docs-nt.component';
import { DocsNcComponent } from './components/docs-nc/docs-nc.component';
import { AnnotationsDocComponent } from './components/annotations-doc/annotations-doc.component';

const routes: Routes = [
  //{ path: '', pathMatch: 'full', redirectTo: 'api/ged/aquisition' },
  { path: 'api/ged/aquisition', component: DocAcqComponent },
  { path: 'api/ged/fiche', component: DocFicheComponent },
  { path: 'api/ged/typage', component: DocTypCaraComponent },
  { path: 'api/ged/caracterisation', component: DocCaraComponent },
  { path: 'api/ged/referencement', component: DocRefComponent },
  { path: 'api/ged/identification', component: DocIdenComponent },
  { path: 'api/ged/search', component: DocsSearchComponent },
  { path: 'api/ged/docs', component: DocsAllComponent },
  { path: 'api/ged/docsNT', component: DocsNtComponent },
  { path: 'api/ged/docsNC', component: DocsNcComponent },
  { path: 'api/ged/archive', component: DocsArchiveComponent, children: [
    {
        path: 'docsNC',
        component: DocsNcComponent,
        outlet: 'secondOutlet'      //secondOutlet the secondary outlet
    },
    {
      path: 'docsNT',
      component: DocsNtComponent,
      outlet: 'secondOutlet'      //secondOutlet the secondary outlet
    },
    {
      path: 'docsAll',
      component: DocsAllComponent,
      outlet: 'secondOutlet'      //secondOutlet the secondary outlet
    },
    {
      path: 'docsSearch',
      component: DocsSearchComponent,
      outlet: 'secondOutlet'      //secondOutlet the secondary outlet
    }
]},
  { path: 'api/ged/annotation', component: DocAnnotComponent },
  { path: 'api/ged/annotations_docs', component: AnnotationsDocComponent },
  //{ path: '**', component: DocAcqComponent },
  //{ path: '**', component: HomeComponent } // If no matching route found, go back to home route
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
