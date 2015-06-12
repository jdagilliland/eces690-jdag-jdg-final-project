#!/usr/bin/env python
'''
The sole purpose of this script is to select sequences from a FASTA file
based on a newline separated list of IDs provided in another file.
'''

from Bio import SeqIO

def read_fasta_file(fname_fasta):
    '''
    This function will read a FASTA file, and return a list of tuples of
    (ID, sequence).
    '''
    f = open(fname_fasta,'r')
    for record in SeqIO.parse(f, 'fasta'):
        yield record

def filter_fasta(idfile, lst_fastafile):
    ids = set([row.rstrip('\n') for row in open(idfile,'r')])
    print((ids))
    for fname in lst_fastafile:
        iter_rec = read_fasta_file(fname)
        for rec in iter_rec:
            if rec.id in ids:
                yield rec
                pass

def write_fasta(fname, iter_rec):
    with open(fname, 'w') as f:
        SeqIO.write(iter_rec, f, 'fasta')
        pass
    return None

def _main():
    import argparse
    parser = argparse.ArgumentParser(
        description='Convert FASTA files to TAB files'
        )
    parser.add_argument('output', metavar='output',
            help="""
            Name of output file.
            """,
            )
    parser.add_argument('ids', metavar='ids',
            help="""
            Single file which lists the ids that you need to collect from
            the FASTA files.
            """,
            )
    parser.add_argument('files', metavar='infiles', nargs='+',
            help="""
            FASTA files from which to draw filtered sequences.
            """,
            )
    argspace = parser.parse_args()
    print((argspace.output))
    write_fasta(argspace.output, filter_fasta(argspace.ids, argspace.files))
    return None

if __name__ == '__main__':
    _main()
