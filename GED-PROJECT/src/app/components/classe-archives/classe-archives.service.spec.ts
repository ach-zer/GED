import { TestBed } from '@angular/core/testing';

import { ClasseArchivesService } from './classe-archives.service';

describe('ClasseArchivesService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ClasseArchivesService = TestBed.get(ClasseArchivesService);
    expect(service).toBeTruthy();
  });
});
