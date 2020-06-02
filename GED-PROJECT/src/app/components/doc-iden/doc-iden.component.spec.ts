import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocIdenComponent } from './doc-iden.component';

describe('DocIdenComponent', () => {
  let component: DocIdenComponent;
  let fixture: ComponentFixture<DocIdenComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocIdenComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocIdenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
