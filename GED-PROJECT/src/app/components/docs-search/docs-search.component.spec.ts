import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocsSearchComponent } from './docs-search.component';

describe('DocsSearchComponent', () => {
  let component: DocsSearchComponent;
  let fixture: ComponentFixture<DocsSearchComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocsSearchComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocsSearchComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
