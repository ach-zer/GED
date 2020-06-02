import { TestBed } from '@angular/core/testing';

import { DocRefService } from './doc-ref.service';

describe('DocRefService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocRefService = TestBed.get(DocRefService);
    expect(service).toBeTruthy();
  });
});
