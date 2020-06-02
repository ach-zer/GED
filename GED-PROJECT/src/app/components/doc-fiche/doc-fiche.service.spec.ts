import { TestBed } from '@angular/core/testing';

import { DocFicheService } from './doc-fiche.service';

describe('DocFicheService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocFicheService = TestBed.get(DocFicheService);
    expect(service).toBeTruthy();
  });
});
