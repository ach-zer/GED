import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocFicheComponent } from './doc-fiche.component';

describe('DocFicheComponent', () => {
  let component: DocFicheComponent;
  let fixture: ComponentFixture<DocFicheComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocFicheComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocFicheComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
