import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocRefComponent } from './doc-ref.component';

describe('DocRefComponent', () => {
  let component: DocRefComponent;
  let fixture: ComponentFixture<DocRefComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocRefComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocRefComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
