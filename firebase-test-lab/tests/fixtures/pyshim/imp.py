"""Minimal shim of the removed 'imp' module (Python >= 3.12) for tests."""
import importlib.machinery
import importlib.util
import sys


def load_source(name, pathname):
  loader = importlib.machinery.SourceFileLoader(name, pathname)
  spec = importlib.util.spec_from_file_location(name, pathname, loader=loader)
  module = importlib.util.module_from_spec(spec)
  sys.modules[name] = module
  loader.exec_module(module)
  return module
