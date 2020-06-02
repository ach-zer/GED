import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocCaraComponent } from './doc-cara.component';

describe('DocCaraComponent', () => {
  let component: DocCaraComponent;
  let fixture: ComponentFixture<DocCaraComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocCaraComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocCaraComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
