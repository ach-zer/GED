import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ClasseArchivesComponent } from './classe-archives.component';

describe('ClasseArchivesComponent', () => {
  let component: ClasseArchivesComponent;
  let fixture: ComponentFixture<ClasseArchivesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ClasseArchivesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ClasseArchivesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
