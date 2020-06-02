import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocsAllComponent } from './docs-all.component';

describe('DocsAllComponent', () => {
  let component: DocsAllComponent;
  let fixture: ComponentFixture<DocsAllComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocsAllComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocsAllComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
