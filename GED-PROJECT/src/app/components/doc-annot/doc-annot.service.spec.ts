import { TestBed } from '@angular/core/testing';

import { DocAnnotService } from './doc-annot.service';

describe('DocAnnotService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocAnnotService = TestBed.get(DocAnnotService);
    expect(service).toBeTruthy();
  });
});
