{-# LANGUAGE CPP #-}
{-# LANGUAGE StandaloneDeriving, TemplateHaskell #-}
{-# LANGUAGE TypeSynonymInstances #-}

{- |
  Module      :  Language.Haskell.TH.Instances.Lift
  Copyright   :  (c) Matt Morrow 2008
  License     :  BSD3
  Maintainer  :  Matt Morrow <mjm2002@gmail.com>
  Stability   :  experimental
  Portability :  portable (template-haskell)
-}

-- | Provides Ord and Lift instances for the TH datatypes.  Also provides
--   Show / Eq for Loc, and Ppr for Loc / Lit.
module Language.Haskell.TH.Instances () where

import Language.Haskell.TH.Syntax
import Language.Haskell.TH.Ppr
import Language.Haskell.TH.Lift (deriveLiftMany)
import GHC.Word ( Word8 )


-- Orphan Show instances
deriving instance Show Loc


-- Orphan Eq instances
deriving instance Eq Loc
deriving instance Eq Info


-- Orphan Ord instances
instance Ord FixityDirection where
  (<=) InfixL _      = True
  (<=) _      InfixR = True
  (<=) InfixN InfixN = True
  (<=) _      _      = False

deriving instance Ord Info
deriving instance Ord Fixity
deriving instance Ord Exp
deriving instance Ord Dec
deriving instance Ord Stmt
deriving instance Ord Type
deriving instance Ord Foreign
deriving instance Ord FunDep
deriving instance Ord Con
deriving instance Ord Body
deriving instance Ord Clause
deriving instance Ord Strict
deriving instance Ord Safety
deriving instance Ord Callconv
deriving instance Ord Guard
deriving instance Ord Range
deriving instance Ord Match
deriving instance Ord Pat
deriving instance Ord Lit

#if MIN_VERSION_template_haskell(2,4,0)
deriving instance Ord FamFlavour
deriving instance Ord Pragma
deriving instance Ord Pred
deriving instance Ord TyVarBndr
#endif

#if MIN_VERSION_template_haskell(2,4,0) && !(MIN_VERSION_template_haskell(2,8,0))
deriving instance Ord InlineSpec
deriving instance Ord Kind
#endif

{- TODO: test?
#if MIN_VERSION_template_haskell(2,5,0) && !(MIN_VERSION_template_haskell(2,7,0))
deriving instance ClassInstance
#endif
-}

#if MIN_VERSION_template_haskell(2,8,0)
deriving instance Ord Inline
deriving instance Ord Phases
deriving instance Ord RuleBndr
deriving instance Ord RuleMatch
deriving instance Ord TyLit
#endif


-- Orphan Ppr instances
-- TODO: make this better
instance Ppr Loc where
  ppr = showtextl . show

instance Ppr Lit where
  ppr l = ppr (LitE l)

-- Orphan Lift instances (for when your TH generates TH!)
-- TODO: Shouldn't this have explicit type signatures?
--       This follows the pattern of the Lift instances for Int / Integer.
instance Lift Word8 where
  lift w = [e| fromIntegral $(lift (fromIntegral w :: Int)) |]

$(deriveLiftMany [ ''Body
                 , ''Callconv
                 , ''Clause
                 , ''Con
                 , ''Dec
                 , ''Exp
                 , ''Fixity
                 , ''FixityDirection
                 , ''Foreign
                 , ''FunDep
                 , ''Guard
                 , ''Info
                 , ''Lit
                 , ''Match
                 , ''Pat
                 , ''Range
                 , ''Safety
                 , ''Stmt
                 , ''Strict
                 , ''Type

#if MIN_VERSION_template_haskell(2,4,0)
                 , ''FamFlavour
                 , ''Pragma
                 , ''Pred
                 , ''TyVarBndr
#endif

#if MIN_VERSION_template_haskell(2,5,0) && !(MIN_VERSION_template_haskell(2,7,0))
                 , ''ClassInstance
#endif

#if MIN_VERSION_template_haskell(2,4,0) && !(MIN_VERSION_template_haskell(2,8,0))
                 , ''InlineSpec
                 , ''Kind
#endif

#if MIN_VERSION_template_haskell(2,8,0)
                 , ''Inline
                 , ''Phases 
                 , ''RuleBndr
                 , ''RuleMatch
                 , ''TyLit
#endif
                 ])

