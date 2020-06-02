import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocsNtComponent } from './docs-nt.component';

describe('DocsNtComponent', () => {
  let component: DocsNtComponent;
  let fixture: ComponentFixture<DocsNtComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocsNtComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocsNtComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
