import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DocsArchiveComponent } from './docs-archive.component';

describe('DocsArchiveComponent', () => {
  let component: DocsArchiveComponent;
  let fixture: ComponentFixture<DocsArchiveComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DocsArchiveComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DocsArchiveComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
