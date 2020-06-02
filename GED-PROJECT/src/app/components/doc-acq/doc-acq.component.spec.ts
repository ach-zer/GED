import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocAcqComponent } from './doc-acq.component';

describe('DocAcqComponent', () => {
  let component: DocAcqComponent;
  let fixture: ComponentFixture<DocAcqComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocAcqComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocAcqComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
