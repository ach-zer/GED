import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocsNcComponent } from './docs-nc.component';

describe('DocsNcComponent', () => {
  let component: DocsNcComponent;
  let fixture: ComponentFixture<DocsNcComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocsNcComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocsNcComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
