import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnnotationsDocComponent } from './annotations-doc.component';

describe('AnnotationsDocComponent', () => {
  let component: AnnotationsDocComponent;
  let fixture: ComponentFixture<AnnotationsDocComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnnotationsDocComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnnotationsDocComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
