import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocAnnotComponent } from './doc-annot.component';

describe('DocAnnotComponent', () => {
  let component: DocAnnotComponent;
  let fixture: ComponentFixture<DocAnnotComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocAnnotComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocAnnotComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
