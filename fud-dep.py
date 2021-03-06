#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
Use FUD HFST automaton to analyse tokenised texts in CONLL-U format.
Create sentence automaton.
Try dependencies in some format...
"""


from argparse import ArgumentParser
from sys import stdin

import hfst
import libhfst


#: magic number for penalty weights
PENALTY_ = 28021984


def load_analyser(filename):
    """Load an automaton from file.

    Args:
        filename:  containing single hfst automaton binary.

    Throws:
        FileNotFoundError if file is not found
    """
    try:
        his = hfst.HfstInputStream(filename)
        return his.read()
    except libhfst.NotTransducerStreamException:
        raise IOError(2, filename) from None


def analyse(fsa, token):
    '''Analyse token using HFST.

    Args:
        fsa: analyser
        token: token to analyse'''
    return fsa.lookup(token)


def get_best_analysis(results):
    '''Get best analysis from HFST pair string stuff.

    Args:
        results: a result of HFST analyse.
    '''
    best = None
    lightest = float('Inf')
    for result in results:
        if result[1] < lightest:
            best = result
            lightest = result[1]
    return best


def hfst2conllu(anal):
    '''Gets back from compiled FUD representation to conllu line.

    Args:
        anal: analysis in HFST format from FUD automaton.
    ̈́'''
    fuds = anal[0].split('|')
    lemma = fuds[0]
    upos = fuds[1]
    ufeats = '|'.join(fuds[2:])
    conllu = ['_', '_', lemma, upos, upos, ufeats, '_', '_', '_',
              'Weight=' + str(anal[1])]
    return conllu


def main():
    """Invoke a simple CLI analyser."""
    argp = ArgumentParser()
    argp.add_argument('-a', '--analyser', metavar='FSA', required=True,
                      help="Path to FSA analyser")
    argp.add_argument('-i', '--input', metavar="INFILE", type=open,
                      dest="infile", help="source of analysis data in CONLLU")
    options = argp.parse_args()
    analyser = load_analyser(options.analyser)
    sentence = hfst.epsilon_fst()
    if not options.infile:
        options.infile = stdin
    for line in options.infile:
        line = line.strip()
        if not line or line == '':
            print("@SENTENCE_SEPARATOR@")
        elif line.startswith('#'):
            print(line)
        else:
            refs = line.strip().split('\t')
            anals = analyse(analyser, refs[1])
            if anals:
                lattice = hfst.empty_fst()
                for anal in anals:
                    surf = refs[1]
                    deep = anal[0]
                    weight = anal[1]
                    print(surf, deep)
                    bleh = hfst.fst({surf: deep})
                    lattice.disjunct(bleh)
                sentence.concatenate(lattice)
            else:
                surf = refs[1]
                deep = refs[1] + "|NOUN|Case=Nom|Number=Sing|Guess=Yes|nsubj"
                print(surf, deep)
                bleh = hfst.fst({surf: deep})
                sentence.concatenate(bleh)
            print("@TOKEN SEPARATOR@")
            foo = hfst.fst("@TOKEN_SEPARATOR@")
            sentence.concatenate(foo)
    exit(0)


if __name__ == "__main__":
    main()
