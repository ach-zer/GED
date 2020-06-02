import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocTypCaraComponent } from './doc-typ-cara.component';

describe('DocTypCaraComponent', () => {
  let component: DocTypCaraComponent;
  let fixture: ComponentFixture<DocTypCaraComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocTypCaraComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocTypCaraComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
