import { TestBed } from '@angular/core/testing';

import { DocsArchiveService } from './docs-archive.service';

describe('DocsArchiveService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocsArchiveService = TestBed.get(DocsArchiveService);
    expect(service).toBeTruthy();
  });
});
