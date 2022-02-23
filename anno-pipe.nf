#!/usr/bin/env nextflow

Channel.fromSRA(['SRR622461'])
    .view()

